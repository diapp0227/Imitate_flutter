//
//  InputHomeView.swift
//  imitate
//
//  Created by garigari0118 on 2025/12/27.
//

import SwiftUI

struct InputHomeView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showErrorMessageAlert = false
    
    /// 種類カテゴリ(収入・支出) の選択状態
    @State var segmentSelected: InputBalanceSegmentView.BalanceType = .income
    /// 金額
    @State private var amountText = ""
    // 選択中のカテゴリ
    /// 指定してる収入カテゴリ名
    @State private var selectedIncomeCategory: String = ""
    /// 指定してる支出カテゴリ名
    @State private var selectedExpensesCategory: String = ""
    
    @State var categoryList = [String]()
    
    // TODO: カテゴリ一覧は、flutter側から取得できるようにする
    /// 収入種類のカテゴリ一覧
    let incomeCategoryList = ["給料", "その他"]
    /// 支出カテゴリ一覧
    let expensesCategoryList = ["食費", "外食費", "日用品", "交通費", "衣服", "交通費", "趣味", "その他"]
    
    /// 指定している日付情報
    @State private var selectedDate = Date()
    
    /// 入力したメモ文字列
    @State private var memoText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // 種類カテゴリ(収入・支出)
                InputBalanceSegmentView(selected: $segmentSelected)
                
                // 金額
                HStack(alignment: .center, spacing: 16) {
                    Text("金額")
                    TextField("0", text: $amountText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
                
                // カテゴリー
                InputBalanceCategoryView(balanceType: $segmentSelected,
                                         selectedIncomeCategory: $selectedIncomeCategory,
                                         selectedExpensesCategory: $selectedExpensesCategory,
                                         incomeCategoryList: incomeCategoryList,
                                         expensesCategoryList: expensesCategoryList)
                // 日付
                DatePicker(
                    "日付",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("メモ(任意)")
                    TextEditor(text: $memoText)
                        .frame(height: 120)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4))
                        )
                }
            }
            .onAppear() {
                selectedIncomeCategory = incomeCategoryList.first ?? ""
                selectedExpensesCategory = expensesCategoryList.first ?? ""
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(radius: 1)
            )
            .padding()
        }
        .alert("金額を入力してください" ,isPresented: $showErrorMessageAlert) {
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    validateInputRecode()
                } label: {
                    Text("保存")
                }
            }
        }
    }
    
    /// 入力した情報を判定
    private func validateInputRecode() {
        // 金額が存在するか
        if amountText.isEmpty {
            showErrorMessageAlert = true
            return
        }
        // 保存処理
        savaRecode()
    }
    
    /// 入力したレコードを保存
    private func savaRecode() {
        // 種類カテゴリで選択していないカテゴリ名を空文字にする
        switch segmentSelected {
        case .income:
            selectedExpensesCategory = ""
        case .expenses:
            selectedIncomeCategory = ""
        }
        // レコード追加
        BalanceRecordRepository.shared.insertRecord(arguments: ["type": segmentSelected.name,
                                                                "incomeCategory": selectedIncomeCategory,
                                                                "expenseCategory": selectedExpensesCategory,
                                                                "amount": amountText,
                                                                "memo": memoText,
                                                                "date": selectedDate.toString(style: .yyyy_MM_dd),
                                                                "createdAt": Date().toString(style: .yyyy_MM_dd),
                                                                "gameFlag": false])
        // レコード取得
        BalanceRecordRepository.shared.selectAll(onSuccess: { result in
            print("success \(String(describing: result?.last))")
        }, onFailure: {
            print("failure")
        })
        dismiss()
    }
}

#Preview {
    InputHomeView()
}
