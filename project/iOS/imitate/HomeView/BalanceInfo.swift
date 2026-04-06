//
//  BalanceInfo.swift
//  imitate
//
//  Created by garigari0118 on 2026/01/26.
//

import Foundation

struct BalanceInfo {
    /// 種類 ... 収入 or 支出
    let type: String?
    /// 収入カテゴリ
    let incomeCategory: String?
    /// 支出カテゴリ
    let expenseCategory: String?
    /// 金額
    let amount: Int?
    /// メモ
    let memo: String?
    /// 日付
    let date: String?
    /// 入力した日付
    let createdAt: String?
    /// ゲームフラグ
    let gameFlag: Bool?
    
    static func parse(info: [String: Any]) -> BalanceInfo {
        return BalanceInfo(
            type: info["type"] as? String,
            incomeCategory: info["income_category"] as? String,
            expenseCategory: info["expense_category"] as? String,
            amount: info["amount"] as? Int,
            memo: info["memo"] as? String,
            date: info["date"] as? String,
            createdAt: info["created_at"] as? String,
            gameFlag: info["game_flag"] as? Bool)
    }

    /// レコードの種類が収入か
    var isIncomeRecord: Bool {
        guard let incomeCategory, !incomeCategory.isEmpty else {
            return false
        }
        return true
    }
    
    /// レコードの種類が支出か
    var isExpenseRecord: Bool {
        guard let expenseCategory, !expenseCategory.isEmpty else {
            return false
        }
        return true
    }
}
