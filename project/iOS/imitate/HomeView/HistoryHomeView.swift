//
//  HistoryHomeView.swift
//  imitate
//
//  Created by garigari0118 on 2025/12/27.
//

import SwiftUI

struct HistoryHomeView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("履歴")
            
            HistoryRowView(
                title: "食費",
                date: "2026/01/18",
                amount: "-¥200",
                amountColor: .red,
                icon: "arrow.down"
            )
            
            Divider()
            
            HistoryRowView(
                title: "給与",
                date: "2026/01/18",
                amount: "+¥400,000",
                amountColor: .green,
                icon: "arrow.up"
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8)
        .padding()
    }
}

#Preview {
    HistoryHomeView()
}
