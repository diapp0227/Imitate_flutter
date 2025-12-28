//
//  TopHomeView.swift
//  imitate
//
//  Created by garigari0118 on 2025/12/27.
//

import SwiftUI

struct TopHomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                BalanceView(type: .income, balance: "200000")
                BalanceView(type: .expenses, balance: "200000")
            }
        }
    }
}

#Preview {
    TopHomeView()
}
