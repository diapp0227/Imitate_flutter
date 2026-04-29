//
//  CategoryRepository.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/29.
//

import Flutter

protocol CategoryRepositoryProtocol {
    func getCategories(type: CategoryType,
                       onSuccess: @escaping (([CategoryInfo]) -> Void),
                       onFailure: @escaping (() -> Void))
    func addCategory(name: String, type: CategoryType,
                     onSuccess: @escaping ((Int) -> Void),
                     onFailure: @escaping (() -> Void))
    func updateCategory(id: Int, name: String,
                        onSuccess: @escaping (() -> Void),
                        onFailure: @escaping (() -> Void))
    func deleteCategory(id: Int,
                        onSuccess: @escaping (() -> Void),
                        onFailure: @escaping (() -> Void))
}

class CategoryRepository: CategoryRepositoryProtocol {

    static let shared = CategoryRepository()

    func getCategories(type: CategoryType,
                       onSuccess: @escaping (([CategoryInfo]) -> Void),
                       onFailure: @escaping (() -> Void)) {
        AppLogger.shared.channelRequest("CategoryRepository.getCategories")
        let arguments: [String: Any] = ["type": type.rawValue]
        FlutterEngineManager.shared.categoryChannel?.invokeMethod("getCategories", arguments: arguments) { result in
            if let list = result as? [[String: Any]] {
                let categories = list.compactMap { (try? CategoryInfo.parse(dictionary: $0)) ?? nil }
                AppLogger.shared.channelSuccess("CategoryRepository.getCategories")
                onSuccess(categories)
            } else if let error = result as? FlutterError {
                AppLogger.shared.channelFailure("CategoryRepository.getCategories", error: error.message ?? "Unknown error")
                onFailure()
            } else {
                AppLogger.shared.channelFailure("CategoryRepository.getCategories", error: "Unexpected result type")
                onFailure()
            }
        }
    }

    func addCategory(name: String, type: CategoryType,
                     onSuccess: @escaping ((Int) -> Void),
                     onFailure: @escaping (() -> Void)) {
        AppLogger.shared.channelRequest("CategoryRepository.addCategory")
        let arguments: [String: Any] = ["name": name, "type": type.rawValue]
        FlutterEngineManager.shared.categoryChannel?.invokeMethod("addCategory", arguments: arguments) { result in
            if let id = result as? Int {
                AppLogger.shared.channelSuccess("CategoryRepository.addCategory")
                onSuccess(id)
            } else if let error = result as? FlutterError {
                AppLogger.shared.channelFailure("CategoryRepository.addCategory", error: error.message ?? "Unknown error")
                onFailure()
            } else {
                AppLogger.shared.channelFailure("CategoryRepository.addCategory", error: "Unexpected result type")
                onFailure()
            }
        }
    }

    func updateCategory(id: Int, name: String,
                        onSuccess: @escaping (() -> Void),
                        onFailure: @escaping (() -> Void)) {
        AppLogger.shared.channelRequest("CategoryRepository.updateCategory")
        let arguments: [String: Any] = ["id": id, "name": name]
        FlutterEngineManager.shared.categoryChannel?.invokeMethod("updateCategory", arguments: arguments) { result in
            if result is Int {
                AppLogger.shared.channelSuccess("CategoryRepository.updateCategory")
                onSuccess()
            } else if let error = result as? FlutterError {
                AppLogger.shared.channelFailure("CategoryRepository.updateCategory", error: error.message ?? "Unknown error")
                onFailure()
            } else {
                AppLogger.shared.channelFailure("CategoryRepository.updateCategory", error: "Unexpected result type")
                onFailure()
            }
        }
    }

    func deleteCategory(id: Int,
                        onSuccess: @escaping (() -> Void),
                        onFailure: @escaping (() -> Void)) {
        AppLogger.shared.channelRequest("CategoryRepository.deleteCategory")
        let arguments: [String: Any] = ["id": id]
        FlutterEngineManager.shared.categoryChannel?.invokeMethod("deleteCategory", arguments: arguments) { result in
            if result is Int {
                AppLogger.shared.channelSuccess("CategoryRepository.deleteCategory")
                onSuccess()
            } else if let error = result as? FlutterError {
                AppLogger.shared.channelFailure("CategoryRepository.deleteCategory", error: error.message ?? "Unknown error")
                onFailure()
            } else {
                AppLogger.shared.channelFailure("CategoryRepository.deleteCategory", error: "Unexpected result type")
                onFailure()
            }
        }
    }
}
