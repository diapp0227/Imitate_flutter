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
    @State private var isManualDismiss = false

    /// 種類カテゴリ(収入・支出) の選択状態
    @State var segmentSelected: InputBalanceSegmentView.BalanceType = .income
    /// 金額
    @State private var amountText = ""

    /// 収入カテゴリ一覧
    @State private var incomeCategoryList: [CategoryInfo] = []
    /// 支出カテゴリ一覧
    @State private var expenseCategoryList: [CategoryInfo] = []
    /// 選択中の収入カテゴリID
    @State private var selectedIncomeCategoryId: Int? = nil
    /// 選択中の支出カテゴリID
    @State private var selectedExpenseCategoryId: Int? = nil

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
                InputBalanceCategoryView(
                    balanceType: $segmentSelected,
                    selectedIncomeCategoryId: $selectedIncomeCategoryId,
                    selectedExpenseCategoryId: $selectedExpenseCategoryId,
                    incomeCategoryList: incomeCategoryList,
                    expenseCategoryList: expenseCategoryList
                )

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
            .logScreenAppeared()
            .onAppear {
                fetchCategories()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(radius: 1)
            )
            .padding()
        }
        .onDisappear {
            if !isManualDismiss {
                AppLogger.shared.userAction("スワイプで閉じる")
            }
            isManualDismiss = false
        }
        .alert("金額を入力してください", isPresented: $showErrorMessageAlert) {
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    AppLogger.shared.userAction("閉じる")
                    isManualDismiss = true
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

    /// カテゴリ一覧をFlutterから取得
    private func fetchCategories() {
        CategoryRepository.shared.getCategories(type: .income) { categories in
            incomeCategoryList = categories
            if selectedIncomeCategoryId == nil {
                selectedIncomeCategoryId = categories.first.flatMap { $0.id }
            }
        } onFailure: {}

        CategoryRepository.shared.getCategories(type: .expense) { categories in
            expenseCategoryList = categories
            if selectedExpenseCategoryId == nil {
                selectedExpenseCategoryId = categories.first.flatMap { $0.id }
            }
        } onFailure: {}

    }

    /// 入力した情報を判定
    private func validateInputRecode() {
        AppLogger.shared.userAction("保存")
        if amountText.isEmpty {
            showErrorMessageAlert = true
            return
        }
        savaRecode()
    }

    /// 入力したレコードを保存
    private func savaRecode() {
        let incomeCategoryId: Int
        let expenseCategoryId: Int

        switch segmentSelected {
        case .income:
            incomeCategoryId = selectedIncomeCategoryId ?? 0
            expenseCategoryId = 0
        case .expenses:
            incomeCategoryId = 0
            expenseCategoryId = selectedExpenseCategoryId ?? 0
        }

        BalanceRecordRepository.shared.insertRecord(arguments: [
            "type": segmentSelected.name,
            "incomeCategoryId": incomeCategoryId,
            "expenseCategoryId": expenseCategoryId,
            "amount": amountText,
            "memo": memoText,
            "date": selectedDate.toString(style: .yyyy_MM_dd),
            "createdAt": Date().toString(style: .yyyy_MM_dd),
            "gameFlag": false
        ])

        BalanceRecordRepository.shared.selectAll(onSuccess: { _ in
        }, onFailure: {
        })

        isManualDismiss = true
        dismiss()
    }
}

#Preview {
    InputHomeView()
}
