//
//  BalanceRecordRepository.swift
//  imitate
//
//  Created by garigari0118 on 2026/01/03.
//

import Flutter

class BalanceRecordRepository {
    
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
}
