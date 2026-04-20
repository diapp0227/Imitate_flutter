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
        FlutterEngineManager.shared.channel?.invokeMethod("selectAll", arguments: nil) { result in
            
            if let result = result as? [[String: Any]] {
                onSuccess(result)
            } else if let error = result as? FlutterError {
                print("Error: \(error.message ?? "Unknown error")")
                onFailure()
            } else if result == nil {
                print("No result returned")
                onFailure()
            } else {
                print("failed selectAll")
                onFailure()
            }
        }
    }
    
    func insertRecord(arguments: [String: Any]) {
        FlutterEngineManager.shared.channel?.invokeMethod("insert", arguments: arguments)
    }

    func getMonthlyIncome(onSuccess: @escaping ((Int) -> Void),
                          onFailure: @escaping (() -> Void)) {
        FlutterEngineManager.shared.channel?.invokeMethod("getMonthlyIncome", arguments: nil) { result in

            if let income = result as? Int {
                onSuccess(income)
            } else if let error = result as? FlutterError {
                print("Error: \(error.message ?? "Unknown error")")
                onFailure()
            } else {
                print("failed getMonthlyIncome")
                onFailure()
            }
        }
    }

    func getMonthlyExpenses(onSuccess: @escaping ((Int) -> Void),
                            onFailure: @escaping (() -> Void)) {
        FlutterEngineManager.shared.channel?.invokeMethod("getMonthlyExpenses", arguments: nil) { result in

            if let expenses = result as? Int {
                onSuccess(expenses)
            } else if let error = result as? FlutterError {
                print("Error: \(error.message ?? "Unknown error")")
                onFailure()
            } else {
                print("failed getMonthlyExpenses")
                onFailure()
            }
        }
    }

    func getDailyBalanceData(year: Int, month: Int,
                             onSuccess: @escaping (([[String: Any]]) -> Void),
                             onFailure: @escaping (() -> Void)) {
        let arguments: [String: Any] = ["year": year, "month": month]
        FlutterEngineManager.shared.channel?.invokeMethod("getDailyBalanceData", arguments: arguments) { result in

            if let data = result as? [[String: Any]] {
                onSuccess(data)
            } else if let error = result as? FlutterError {
                print("Error: \(error.message ?? "Unknown error")")
                onFailure()
            } else {
                print("failed getDailyBalanceData")
                onFailure()
            }
        }
    }

    func getAvailableYearMonths(onSuccess: @escaping (([String]) -> Void),
                                onFailure: @escaping (() -> Void)) {
        FlutterEngineManager.shared.channel?.invokeMethod("getAvailableYearMonths", arguments: nil) { result in

            if let yearMonths = result as? [String] {
                onSuccess(yearMonths)
            } else if let error = result as? FlutterError {
                print("Error: \(error.message ?? "Unknown error")")
                onFailure()
            } else {
                print("failed getAvailableYearMonths")
                onFailure()
            }
        }
    }
}
