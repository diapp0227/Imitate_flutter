//
//  BalanceView.swift
//  imitate
//
//  Created by garigari0118 on 2025/12/27.
//

import SwiftUI

struct BalanceView: View {
    
    var type: BalanceType
    var balance: String
    
    enum BalanceType {
        case income
        case expenses
        
        var name: String {
            switch self {
            case .income:
                "今月の収入"
            case .expenses:
                "今月の支出"
            }
        }

        var backGroundColor: Color {
            switch self {
            case .income:
                .green
            case .expenses:
                .red
            }
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(type.name)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("¥")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(balance)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(
                maxWidth: UIScreen.main.bounds.width * 0.9
            )
        }
        .padding(16)
        .background(type.backGroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
        .padding(.horizontal)

    }
}

#Preview {
    BalanceView(type: .income, balance: "2000")
}
