//
//  CategoryManagementViewModel.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/29.
//

import Foundation

class CategoryManagementViewModel: ObservableObject {

    enum ViewState {
        case loading
        case loaded
        case error
    }

    private enum FetchError: Error {
        case failed
    }

    @Published var viewState: ViewState = .loading
    @Published var incomeCategories: [CategoryInfo] = []
    @Published var expenseCategories: [CategoryInfo] = []

    func fetchCategories() {
        Task { @MainActor in
            viewState = .loading
            do {
                async let income = getCategories(type: .income)
                async let expense = getCategories(type: .expense)
                incomeCategories = try await income
                expenseCategories = try await expense
                viewState = .loaded
            } catch {
                viewState = .error
            }
        }
    }

    func addCategory(name: String, type: CategoryType) {
        CategoryRepository.shared.addCategory(name: name, type: type) { [weak self] _ in
            self?.fetchCategories()
        } onFailure: {}
    }

    func updateCategory(id: Int, name: String) {
        CategoryRepository.shared.updateCategory(id: id, name: name) { [weak self] in
            self?.fetchCategories()
        } onFailure: {}
    }

    func deleteCategory(id: Int, type: CategoryType) {
        CategoryRepository.shared.deleteCategory(id: id) { [weak self] in
            self?.fetchCategories()
        } onFailure: {}
    }

    private func getCategories(type: CategoryType) async throws -> [CategoryInfo] {
        try await withCheckedThrowingContinuation { continuation in
            CategoryRepository.shared.getCategories(type: type) { categories in
                continuation.resume(returning: categories)
            } onFailure: {
                continuation.resume(throwing: FetchError.failed)
            }
        }
    }
}
