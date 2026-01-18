#!/usr/bin/env node

import Anthropic from '@anthropic-ai/sdk';
import { Octokit } from '@octokit/rest';
import { readFile } from 'fs/promises';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

// Environment variables
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const REPO_OWNER = process.env.GITHUB_REPOSITORY_OWNER;
const REPO_NAME = process.env.GITHUB_REPOSITORY_NAME;
const PR_NUMBER = process.env.PR_NUMBER;

// Initialize clients
const anthropic = new Anthropic({
  apiKey: ANTHROPIC_API_KEY,
});

const octokit = new Octokit({
  auth: GITHUB_TOKEN,
});

// Load configuration
async function loadConfig() {
  const configPath = resolve(__dirname, '../review-config.json');
  const configData = await readFile(configPath, 'utf-8');
  return JSON.parse(configData);
}

// Get PR information
async function getPRInfo() {
  try {
    const { data: pr } = await octokit.pulls.get({
      owner: REPO_OWNER,
      repo: REPO_NAME,
      pull_number: parseInt(PR_NUMBER),
    });
    return pr;
  } catch (error) {
    console.error('Error fetching PR info:', error.message);
    throw error;
  }
}

// Get PR files and diffs
async function getPRFiles() {
  try {
    const { data: files } = await octokit.pulls.listFiles({
      owner: REPO_OWNER,
      repo: REPO_NAME,
      pull_number: parseInt(PR_NUMBER),
    });
    return files;
  } catch (error) {
    console.error('Error fetching PR files:', error.message);
    throw error;
  }
}

// Check if file should be reviewed
function shouldReviewFile(filename, config) {
  // Check exclusion patterns
  for (const pattern of config.excludePatterns) {
    const regex = new RegExp(pattern.replace(/\*\*/g, '.*').replace(/\*/g, '[^/]*'));
    if (regex.test(filename)) {
      return false;
    }
  }

  // Check if file matches any platform pattern
  for (const platform of Object.values(config.platforms)) {
    for (const pattern of platform.patterns) {
      const regex = new RegExp(pattern.replace(/\*\*/g, '.*').replace(/\*/g, '[^/]*'));
      if (regex.test(filename)) {
        return true;
      }
    }
  }

  return false;
}

// Categorize files by platform
function categorizeFiles(files, config) {
  const categorized = {
    flutter: [],
    android: [],
    ios: [],
    documentation: [],
    other: []
  };

  for (const file of files) {
    let matched = false;
    for (const [platformName, platform] of Object.entries(config.platforms)) {
      for (const pattern of platform.patterns) {
        const regex = new RegExp(pattern.replace(/\*\*/g, '.*').replace(/\*/g, '[^/]*'));
        if (regex.test(file.filename)) {
          categorized[platformName].push(file);
          matched = true;
          break;
        }
      }
      if (matched) break;
    }
    if (!matched) {
      categorized.other.push(file);
    }
  }

  return categorized;
}

// Format PR diff for Claude
function formatDiffForClaude(files, config) {
  const relevantFiles = files.filter(file => shouldReviewFile(file.filename, config));

  if (relevantFiles.length === 0) {
    return null;
  }

  const categorized = categorizeFiles(relevantFiles, config);

  let formatted = '## Changed Files\n\n';

  for (const [platform, platformFiles] of Object.entries(categorized)) {
    if (platformFiles.length > 0) {
      formatted += `### ${platform.charAt(0).toUpperCase() + platform.slice(1)}\n`;
      for (const file of platformFiles) {
        formatted += `- ${file.filename} (+${file.additions}/-${file.deletions})\n`;
      }
      formatted += '\n';
    }
  }

  formatted += '## Code Diffs\n\n';

  for (const file of relevantFiles) {
    formatted += `### File: ${file.filename}\n`;
    formatted += `Status: ${file.status}\n`;
    formatted += `Changes: +${file.additions}/-${file.deletions}\n\n`;

    if (file.patch) {
      formatted += '```diff\n';
      formatted += file.patch;
      formatted += '\n```\n\n';
    }
  }

  return formatted;
}

// Create system prompt
function createSystemPrompt(config) {
  return `You are a senior code reviewer for a multi-platform mobile application project.

**Architecture:**
- Flutter (Dart): Business logic and SQLite database
- SwiftUI (iOS): iOS-specific UI
- Jetpack Compose (Android): Android-specific UI
- MethodChannel for Flutter ↔ Native communication

**Review Focus:**
${config.reviewFocus.map(focus => `- ${focus}`).join('\n')}

**Output Format:**
Provide a structured review with the following sections:

1. **Security Issues** (if any):
   - List specific security concerns (SQL injection, null safety violations, etc.)
   - Include file paths and line references
   - Severity: Critical/High/Medium

2. **Cross-Platform Consistency** (if applicable):
   - MethodChannel contract mismatches
   - Repository pattern implementation differences
   - Inconsistent error handling

3. **Code Quality**:
   - Best practice violations
   - Unused imports or dead code
   - Magic numbers/strings
   - Complex functions that need refactoring

4. **Documentation** (if applicable):
   - Missing documentation for public APIs
   - Inconsistencies between docs and implementation

5. **Suggestions**:
   - Specific, actionable improvement recommendations

**Important:**
- Be concise and specific
- Reference exact file paths and line numbers when possible
- Focus on issues that could cause bugs or security problems
- Acknowledge good practices when you see them
- If no issues found, briefly explain what was reviewed and confirm it looks good`;
}

// Create user prompt
function createUserPrompt(pr, diffText) {
  return `Please review the following Pull Request:

**Title:** ${pr.title}

**Description:**
${pr.body || 'No description provided'}

**Branch:** ${pr.head.ref} → ${pr.base.ref}

${diffText}

Please provide a thorough code review focusing on the review criteria.`;
}

// Call Claude API for review
async function getClaudeReview(pr, diffText, config) {
  try {
    console.log('Calling Claude API for code review...');

    const message = await anthropic.messages.create({
      model: 'claude-opus-4-5-20251101',
      max_tokens: 4096,
      temperature: 0,
      system: createSystemPrompt(config),
      messages: [
        {
          role: 'user',
          content: createUserPrompt(pr, diffText)
        }
      ]
    });

    return message.content[0].text;
  } catch (error) {
    console.error('Error calling Claude API:', error.message);
    throw error;
  }
}

// Post review comment to PR
async function postReviewComment(reviewText) {
  try {
    const commentBody = `## 🤖 Claude Code Review

${reviewText}

---
*Automated review powered by Claude Opus 4.5 | Triggered by \`needs-review\` label*`;

    await octokit.issues.createComment({
      owner: REPO_OWNER,
      repo: REPO_NAME,
      issue_number: parseInt(PR_NUMBER),
      body: commentBody,
    });

    console.log('Review comment posted successfully');
  } catch (error) {
    console.error('Error posting comment:', error.message);
    throw error;
  }
}

// Main execution
async function main() {
  try {
    // Validate environment variables
    if (!ANTHROPIC_API_KEY) {
      throw new Error('ANTHROPIC_API_KEY environment variable is required');
    }
    if (!GITHUB_TOKEN) {
      throw new Error('GITHUB_TOKEN environment variable is required');
    }
    if (!PR_NUMBER) {
      throw new Error('PR_NUMBER environment variable is required');
    }

    console.log(`Starting code review for PR #${PR_NUMBER}...`);

    // Load configuration
    const config = await loadConfig();
    console.log('Configuration loaded');

    // Get PR information
    const pr = await getPRInfo();
    console.log(`PR Info: ${pr.title}`);

    // Get PR files and diffs
    const files = await getPRFiles();
    console.log(`Found ${files.length} changed files`);

    // Format diff for Claude
    const diffText = formatDiffForClaude(files, config);

    if (!diffText) {
      console.log('No relevant files to review (all files matched exclusion patterns)');
      await postReviewComment('No relevant code files found to review. All changed files are excluded based on the review configuration.');
      return;
    }

    // Get review from Claude
    const review = await getClaudeReview(pr, diffText, config);
    console.log('Review received from Claude');

    // Post review comment
    await postReviewComment(review);

    console.log('Code review completed successfully');
  } catch (error) {
    console.error('Code review failed:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

main();
