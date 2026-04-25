# ログ設計ドキュメント

## 実装状況

| プラットフォーム | 実装状況 |
|----------------|---------|
| iOS | ✅ 実装済み |
| Android | 🔲 未実装 |
| Flutter | 🔲 未実装 |

---

## iOS

### 実装方針

| 項目 | 内容 |
|------|------|
| ログフレームワーク | `os.Logger`（Apple標準） |
| 対象バージョン | iOS 14以上 |
| ログレベル | `debug`（開発時のみ表示・リリースビルドでは非表示） |
| ログ言語 | 英語（ボタン名など表示文言は日本語） |
| プレフィックス | 全ログに `【iOS】` を付与してFlutter/Androidと区別 |
| ファイル名取得 | `#fileID` をデフォルト引数に使用し、呼び出し元ファイル名を自動取得 |

### カテゴリ構成

| カテゴリ | 用途 |
|---------|------|
| `Screen` | 画面表示ログ |
| `Action` | ユーザーアクションログ |
| `Channel` | Flutter MethodChannel通信ログ |

### 実装ファイル

| ファイル | 役割 |
|---------|------|
| `Manager/AppLogger.swift` | ログ出力の中枢。`os.Logger` のラッパー。将来のFirebase対応のため `LogDestination` プロトコルを定義 |
| `Extension/ViewExtension.swift` | `logScreenAppeared()` カスタムモディファイア |

### ログ一覧

#### 画面表示

| メソッド | 呼び出し方 | 出力例 |
|---------|-----------|-------|
| `screenAppeared(file:)` | `.logScreenAppeared()` | `【iOS】[imitate/TopHomeView.swift] appeared` |

#### ユーザーアクション

| メソッド | 呼び出し方 | 出力例 |
|---------|-----------|-------|
| `userAction(_:on:)` | `AppLogger.shared.userAction("保存")` | `【iOS】[imitate/InputHomeView.swift] '保存' action` |

**現在ログを出力しているアクション一覧：**

| 画面 | アクション名 |
|------|------------|
| TopHomeView | 収支入力 |
| TopHomeView | 前月 |
| TopHomeView | 次月 |
| TopHomeView | 年月選択 |
| InputHomeView | 保存 |
| InputHomeView | 閉じる |
| InputHomeView | スワイプで閉じる |

#### Channel通信

| メソッド | タイミング | 出力例 |
|---------|----------|-------|
| `channelRequest(_:)` | invokeMethod 呼び出し前 | `【iOS】[BalanceRecordRepository.selectAll] channel requesting` |
| `channelSuccess(_:)` | 成功コールバック | `【iOS】[BalanceRecordRepository.selectAll] channel success` |
| `channelFailure(_:error:)` | 失敗コールバック | `【iOS】[BalanceRecordRepository.selectAll] channel failure: Unknown error` |

**現在ログを出力しているメソッド一覧：**

| メソッド |
|---------|
| `BalanceRecordRepository.selectAll` |
| `BalanceRecordRepository.insert` |
| `BalanceRecordRepository.getMonthlyIncome` |
| `BalanceRecordRepository.getMonthlyExpenses` |
| `BalanceRecordRepository.getDailyBalanceData` |
| `BalanceRecordRepository.getAvailableYearMonths` |

### ログ確認方法

**Xcodeデバッグコンソール：**  
デバッガ接続中に自動で出力される。

**ターミナル（リアルタイム）：**
```bash
log stream --device --predicate 'subsystem == "diapp0227.imitate"' --level debug
```

### 将来対応

- Firebase導入時は `LogDestination` プロトコルを実装した `FirebaseLogDestination` を作成し、`AppLogger.shared.destinations` に追加する

---

## Android

🔲 未実装

---

## Flutter

🔲 未実装
