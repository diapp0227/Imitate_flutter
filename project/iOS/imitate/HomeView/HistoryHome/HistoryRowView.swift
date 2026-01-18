//
//  HistoryRowView.swift
//  imitate
//
//  Created by garigari0118 on 2026/01/19.
//

import SwiftUI

struct HistoryRowView: View {
    let title: String
    let date: String
    let amount: String
    let amountColor: Color
    let icon: String

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(amountColor)
                    .padding(8)
                    .background(amountColor.opacity(0.15))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            HStack(spacing: 8) {
                Text(amount)
                    .foregroundColor(amountColor)
                    .fontWeight(.semibold)

                Image(systemName: "trash")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    HistoryRowView(title: "", date: "", amount: "", amountColor: .red, icon: "")
}
