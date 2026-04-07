//
//  HistoryHomeView.swift
//  imitate
//
//  Created by garigari0118 on 2025/12/27.
//

import SwiftUI

struct HistoryHomeView: View {

    struct HistoryInfo: Identifiable {
        var id: Int
        let title: String
        let type: HistoryRowView.BalanceType
        let date: String
        let amount: String
    }

    @StateObject private var viewModel = HistoryHomeViewModel()

    var body: some View {
        VStack(spacing: 12) {
            Text("履歴")
            List(viewModel.historyList) { row in
                HistoryRowView(title: row.title,
                               date: row.date,
                               amount: row.amount,
                               type: row.type)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8)
        .padding()
        .onAppear() {
            viewModel.loadHistory()
        }
    }
}

#Preview {
    HistoryHomeView()
}
