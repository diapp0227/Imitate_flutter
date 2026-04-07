//
//  HistoryInfoMapper.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/07.
//

import Foundation

/// BalanceRecordInfo を HistoryInfo に変換するマッパークラス
struct HistoryInfoMapper {

    /// レコードのリストを HistoryInfo のリストに変換する
    /// - Parameter records: 変換元のレコードリスト
    /// - Returns: 変換後の HistoryInfo リスト
    func map(_ records: [[String: Any]]?) -> [HistoryHomeView.HistoryInfo] {
        guard let records, records.count >= 1 else {
            return []
        }

        return records.enumerated().compactMap { index, record in
            mapSingleRecord(index: index, record: record)
        }
    }

    /// 単一のレコードを HistoryInfo に変換する
    /// - Parameters:
    ///   - index: レコードのインデックス（ID として使用）
    ///   - record: 変換元のレコード
    /// - Returns: 変換後の HistoryInfo（変換失敗時は nil）
    private func mapSingleRecord(index: Int, record: [String: Any]) -> HistoryHomeView.HistoryInfo? {
        guard let balanceInfo = try? BalanceRecordInfo.parse(dictionary: record) else {
            return nil
        }

        if balanceInfo.isIncomeRecord {
            return createIncomeInfo(index: index, from: balanceInfo)
        } else if balanceInfo.isExpenseRecord {
            return createExpenseInfo(index: index, from: balanceInfo)
        }

        return nil
    }

    /// 収入レコードから HistoryInfo を作成する
    /// - Parameters:
    ///   - index: レコードのインデックス
    ///   - balanceInfo: 収入レコード情報
    /// - Returns: 収入タイプの HistoryInfo
    private func createIncomeInfo(index: Int, from balanceInfo: BalanceRecordInfo) -> HistoryHomeView.HistoryInfo {
        return HistoryHomeView.HistoryInfo(
            id: index,
            title: balanceInfo.incomeCategory ?? "",
            type: .income,
            date: balanceInfo.date ?? "",
            amount: "\(balanceInfo.amount ?? .zero)"
        )
    }

    /// 支出レコードから HistoryInfo を作成する
    /// - Parameters:
    ///   - index: レコードのインデックス
    ///   - balanceInfo: 支出レコード情報
    /// - Returns: 支出タイプの HistoryInfo
    private func createExpenseInfo(index: Int, from balanceInfo: BalanceRecordInfo) -> HistoryHomeView.HistoryInfo {
        return HistoryHomeView.HistoryInfo(
            id: index,
            title: balanceInfo.expenseCategory ?? "",
            type: .expenses,
            date: balanceInfo.date ?? "",
            amount: "\(balanceInfo.amount ?? .zero)"
        )
    }
}
