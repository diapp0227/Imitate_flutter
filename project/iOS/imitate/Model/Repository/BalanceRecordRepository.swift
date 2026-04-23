//
//  BalanceRecordRepository.swift
//  imitate
//
//  Created by garigari0118 on 2026/01/03.
//

import Flutter

protocol BalanceRecordRepositoryProtocol {
    func selectAll(onSuccess: @escaping (([[String: Any]]?) -> Void),
                   onFailure: @escaping (() -> Void))
    func insertRecord(arguments: [String: Any])
    func getMonthlyIncome(onSuccess: @escaping ((Int) -> Void),
                          onFailure: @escaping (() -> Void))
    func getMonthlyExpenses(onSuccess: @escaping ((Int) -> Void),
                            onFailure: @escaping (() -> Void))
    func getDailyBalanceData(year: Int, month: Int,
                             onSuccess: @escaping (([[String: Any]]) -> Void),
                             onFailure: @escaping (() -> Void))
    func getAvailableYearMonths(onSuccess: @escaping (([String]) -> Void),
                                onFailure: @escaping (() -> Void))
}

class BalanceRecordRepository: BalanceRecordRepositoryProtocol {

    static let shared = BalanceRecordRepository()

    func selectAll(onSuccess: @escaping (([[String: Any]]?) -> Void),
                   onFailure: @escaping (() -> Void)) {
        AppLogger.shared.networkRequest("BalanceRecordRepository.selectAll")
        FlutterEngineManager.shared.channel?.invokeMethod("selectAll", arguments: nil) { result in
            if let result = result as? [[String: Any]] {
                AppLogger.shared.networkSuccess("BalanceRecordRepository.selectAll")
                onSuccess(result)
            } else if let error = result as? FlutterError {
                AppLogger.shared.networkFailure("BalanceRecordRepository.selectAll", error: error.message ?? "Unknown error")
                onFailure()
            } else if result == nil {
                AppLogger.shared.networkFailure("BalanceRecordRepository.selectAll", error: "No result returned")
                onFailure()
            } else {
                AppLogger.shared.networkFailure("BalanceRecordRepository.selectAll", error: "Unexpected result type")
                onFailure()
            }
        }
    }

    func insertRecord(arguments: [String: Any]) {
        AppLogger.shared.networkRequest("BalanceRecordRepository.insert")
        FlutterEngineManager.shared.channel?.invokeMethod("insert", arguments: arguments)
    }

    func getMonthlyIncome(onSuccess: @escaping ((Int) -> Void),
                          onFailure: @escaping (() -> Void)) {
        AppLogger.shared.networkRequest("BalanceRecordRepository.getMonthlyIncome")
        FlutterEngineManager.shared.channel?.invokeMethod("getMonthlyIncome", arguments: nil) { result in
            if let income = result as? Int {
                AppLogger.shared.networkSuccess("BalanceRecordRepository.getMonthlyIncome")
                onSuccess(income)
            } else if let error = result as? FlutterError {
                AppLogger.shared.networkFailure("BalanceRecordRepository.getMonthlyIncome", error: error.message ?? "Unknown error")
                onFailure()
            } else {
                AppLogger.shared.networkFailure("BalanceRecordRepository.getMonthlyIncome", error: "Unexpected result type")
                onFailure()
            }
        }
    }

    func getMonthlyExpenses(onSuccess: @escaping ((Int) -> Void),
                            onFailure: @escaping (() -> Void)) {
        AppLogger.shared.networkRequest("BalanceRecordRepository.getMonthlyExpenses")
        FlutterEngineManager.shared.channel?.invokeMethod("getMonthlyExpenses", arguments: nil) { result in
            if let expenses = result as? Int {
                AppLogger.shared.networkSuccess("BalanceRecordRepository.getMonthlyExpenses")
                onSuccess(expenses)
            } else if let error = result as? FlutterError {
                AppLogger.shared.networkFailure("BalanceRecordRepository.getMonthlyExpenses", error: error.message ?? "Unknown error")
                onFailure()
            } else {
                AppLogger.shared.networkFailure("BalanceRecordRepository.getMonthlyExpenses", error: "Unexpected result type")
                onFailure()
            }
        }
    }

    func getDailyBalanceData(year: Int, month: Int,
                             onSuccess: @escaping (([[String: Any]]) -> Void),
                             onFailure: @escaping (() -> Void)) {
        AppLogger.shared.networkRequest("BalanceRecordRepository.getDailyBalanceData")
        let arguments: [String: Any] = ["year": year, "month": month]
        FlutterEngineManager.shared.channel?.invokeMethod("getDailyBalanceData", arguments: arguments) { result in
            if let data = result as? [[String: Any]] {
                AppLogger.shared.networkSuccess("BalanceRecordRepository.getDailyBalanceData")
                onSuccess(data)
            } else if let error = result as? FlutterError {
                AppLogger.shared.networkFailure("BalanceRecordRepository.getDailyBalanceData", error: error.message ?? "Unknown error")
                onFailure()
            } else {
                AppLogger.shared.networkFailure("BalanceRecordRepository.getDailyBalanceData", error: "Unexpected result type")
                onFailure()
            }
        }
    }

    func getAvailableYearMonths(onSuccess: @escaping (([String]) -> Void),
                                onFailure: @escaping (() -> Void)) {
        AppLogger.shared.networkRequest("BalanceRecordRepository.getAvailableYearMonths")
        FlutterEngineManager.shared.channel?.invokeMethod("getAvailableYearMonths", arguments: nil) { result in
            if let yearMonths = result as? [String] {
                AppLogger.shared.networkSuccess("BalanceRecordRepository.getAvailableYearMonths")
                onSuccess(yearMonths)
            } else if let error = result as? FlutterError {
                AppLogger.shared.networkFailure("BalanceRecordRepository.getAvailableYearMonths", error: error.message ?? "Unknown error")
                onFailure()
            } else {
                AppLogger.shared.networkFailure("BalanceRecordRepository.getAvailableYearMonths", error: "Unexpected result type")
                onFailure()
            }
        }
    }
}
