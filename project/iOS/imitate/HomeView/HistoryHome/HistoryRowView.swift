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
    let type: BalanceType
    
    enum BalanceType {
        case income
        case expenses
        
        var amountTextColor: Color {
            switch self {
            case .income:
                return .green
            case .expenses:
                return .red
            }
        }
        
        var icon: String {
            switch self {
            case .income:
                return "arrow.up"
            case .expenses:
                return "arrow.down"
            }
        }
    }

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: type.icon)
                    .foregroundColor(type.amountTextColor)
                    .padding(8)
                    .background(type.amountTextColor.opacity(0.15))
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
                    .foregroundColor(type.amountTextColor)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    HistoryRowView(title: "", date: "", amount: "", type: .income)
}
