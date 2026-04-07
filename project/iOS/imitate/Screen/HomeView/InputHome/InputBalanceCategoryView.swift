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
    /// 指定してる収入カテゴリ名
    @Binding var selectedIncomeCategory: String
    /// 指定してる支出カテゴリ名
    @Binding var selectedExpensesCategory: String
    /// 収入カテゴリ一覧
    var incomeCategoryList: [String]
    /// 支出カテゴリ一覧
    var expensesCategoryList: [String]
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("カテゴリー")
            
            switch balanceType {
            case .income:
                Picker(selectedIncomeCategory.isEmpty ? "選択してください" : selectedIncomeCategory, selection: $selectedIncomeCategory) {
                    if !selectedIncomeCategory.isEmpty {
                        ForEach(Array(incomeCategoryList.enumerated()), id: \.offset) { _, category in
                            Text(category).tag(category)
                        }
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4))
                )
            case .expenses:
                Picker(selectedExpensesCategory.isEmpty ? "選択してください" : selectedExpensesCategory, selection: $selectedExpensesCategory) {
                    if !selectedIncomeCategory.isEmpty {
                        ForEach(Array(expensesCategoryList.enumerated()), id: \.offset) { _, category in
                            Text(category).tag(category)
                        }
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
    }
}

//#Preview {
//    InputBalanceCategoryView()
//}
