//
//  BalanceInfo.swift
//  imitate
//
//  Created by garigari0118 on 2026/01/26.
//

import Foundation

struct BalanceInfo: Codable {
    /// 種類 ... 収入 or 支出
    var type: String?
    /// 収入カテゴリ
    var incomeCategory: String?
    /// 支出カテゴリ
    var expenseCategory: String?
    /// 金額
    var amount: Int?
    /// メモ
    var memo: String?
    /// 日付
    var date: String?
    /// 入力した日付
    var createdAt: String?
    /// ゲームフラグ
    var gameFlag: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case incomeCategory = "income_category"
        case expenseCategory = "expense_category"
        case amount
        case memo
        case date
        case createdAt = "created_at"
        case gameFlag = "game_flag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        incomeCategory = try values.decodeIfPresent(String.self, forKey: .incomeCategory)
        expenseCategory = try values.decodeIfPresent(String.self, forKey: .expenseCategory)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        memo = try values.decodeIfPresent(String.self, forKey: .memo)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        gameFlag = try values.decodeIfPresent(Int.self, forKey: .gameFlag)
    }
    
    static func parse(dictionary: [String: Any]) throws -> BalanceInfo? {
        try dictionary.decode(self)
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
