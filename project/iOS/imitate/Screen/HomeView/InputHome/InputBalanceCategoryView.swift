//
//  InputBalanceCategoryView.swift
//  imitate
//
//  Created by garigari0118 on 2026/01/04.
//

import SwiftUI

struct InputBalanceCategoryView: View {

    /// 指定してる種類
    @Binding var balanceType: InputBalanceSegmentView.BalanceType
    /// 選択中の収入カテゴリID
    @Binding var selectedIncomeCategoryId: Int?
    /// 選択中の支出カテゴリID
    @Binding var selectedExpenseCategoryId: Int?
    /// 収入カテゴリ一覧
    var incomeCategoryList: [CategoryInfo]
    /// 支出カテゴリ一覧
    var expenseCategoryList: [CategoryInfo]

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("カテゴリー")

            switch balanceType {
            case .income:
                categoryPicker(
                    selectedId: $selectedIncomeCategoryId,
                    categories: incomeCategoryList
                )
            case .expenses:
                categoryPicker(
                    selectedId: $selectedExpenseCategoryId,
                    categories: expenseCategoryList
                )
            }
        }
    }

    private func categoryPicker(selectedId: Binding<Int?>, categories: [CategoryInfo]) -> some View {
        let label = categories.first(where: { $0.id == selectedId.wrappedValue })?.name ?? "選択してください"
        return Picker(label, selection: selectedId) {
            ForEach(categories, id: \.id) { category in
                Text(category.name ?? "").tag(category.id)
            }
        }
        .pickerStyle(.menu)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.4))
        )
    }
}
