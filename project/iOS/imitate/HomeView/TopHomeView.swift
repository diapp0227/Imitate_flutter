//
//  TopHomeView.swift
//  imitate
//
//  Created by garigari0118 on 2025/12/27.
//

import SwiftUI

struct TopHomeView: View {
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    BalanceView(type: .income, balance: "200000")
                    BalanceView(type: .expenses, balance: "200000")
                }
            }
            
            VStack {
              Spacer()
              HStack {
                Spacer()
                Button(action: {
                    tapPlusButton()
                }) {
                  Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                }
                .padding()
              }
            }
        }
    }
    
    func tapPlusButton() {

// レコード追加
//        BalanceRecordRepository.shared.insertRecord(arguments: ["type": "支出",
//                                                                "incomeCategory": "",
//                                                                "expenseCategory": "食費",
//                                                                "amount": 1200,
//                                                                "memo": "昼ごはん",
//                                                                "date": "2026-01-02",
//                                                                "createdAt": "2026-01-02",
//                                                                "gameFlag": false])

// レコード取得
//        BalanceRecordRepository.shared.selectAll(onSuccess: {_ in
//            print("success")
//        }, onFailure: {
//            print("failure")
//        })
    }
}

#Preview {
    TopHomeView()
}
