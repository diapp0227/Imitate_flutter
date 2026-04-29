//
//  CategoryManagementView.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/29.
//

import SwiftUI

struct CategoryManagementView: View {

    @StateObject private var viewModel = CategoryManagementViewModel()

    @State private var selectedType: CategoryType = .income
    @State private var showAddAlert = false
    @State private var showEditAlert = false
    @State private var showActionSheet = false
    @State private var editingCategory: CategoryInfo? = nil
    @State private var inputName = ""

    private var currentCategories: [CategoryInfo] {
        switch selectedType {
        case .income:   return viewModel.incomeCategories
        case .expense:  return viewModel.expenseCategories
        }
    }

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
            case .loaded:
                loadedView
            case .error:
                Text("カテゴリの取得に失敗しました")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("カテゴリ管理")
        .navigationBarTitleDisplayMode(.inline)
        .alert("カテゴリを追加", isPresented: $showAddAlert) {
            TextField("カテゴリ名", text: $inputName)
            Button("追加") {
                let name = inputName.trimmingCharacters(in: .whitespaces)
                if !name.isEmpty {
                    viewModel.addCategory(name: name, type: selectedType)
                }
            }
            Button("キャンセル", role: .cancel) {}
        }
        .alert("カテゴリ名を変更", isPresented: $showEditAlert) {
            TextField("カテゴリ名", text: $inputName)
            Button("保存") {
                let name = inputName.trimmingCharacters(in: .whitespaces)
                if let id = editingCategory?.id, !name.isEmpty {
                    viewModel.updateCategory(id: id, name: name)
                }
            }
            Button("キャンセル", role: .cancel) {}
        }
        .confirmationDialog("操作を選択", isPresented: $showActionSheet, titleVisibility: .hidden) {
            Button("編集") {
                inputName = editingCategory?.name ?? ""
                showEditAlert = true
            }
            if currentCategories.count > 1 {
                Button("削除", role: .destructive) {
                    if let id = editingCategory?.id {
                        viewModel.deleteCategory(id: id, type: selectedType)
                    }
                }
            }
            Button("キャンセル", role: .cancel) {}
        }
        .onAppear {
            viewModel.fetchCategories()
        }
    }

    private var loadedView: some View {
        VStack(spacing: 0) {
            Picker("種類", selection: $selectedType) {
                Text("収入").tag(CategoryType.income)
                Text("支出").tag(CategoryType.expense)
            }
            .pickerStyle(.segmented)
            .padding()

            List {
                Section {
                    ForEach(currentCategories, id: \.id) { category in
                        Button {
                            editingCategory = category
                            showActionSheet = true
                        } label: {
                            Text(category.name ?? "")
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    Button {
                        inputName = ""
                        showAddAlert = true
                    } label: {
                        Label("カテゴリを追加", systemImage: "plus")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryManagementView()
    }
}
