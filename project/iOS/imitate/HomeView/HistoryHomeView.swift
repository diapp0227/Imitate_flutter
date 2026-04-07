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
    
    @State private var list = [HistoryInfo]()
    
    var body: some View {
        VStack(spacing: 12) {
            Text("履歴")
            List(list) { row in
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
            getHistoryInfoLists { getInfo in
                self.list = getInfo
            }
        }
    }
    
    func getHistoryInfoLists(completion: (([HistoryInfo]) ->Void)?) {
        BalanceRecordRepository.shared.selectAll(onSuccess: { info in
            guard let info, info.count >= 1 else {
                return
            }
        
            var list = [HistoryInfo]()
            
            info.enumerated().forEach { index, getInfo in
                do {
                    guard let balanceInfo = try BalanceInfo.parse(dictionary: getInfo) else {
                        return
                    }
                    
                    if balanceInfo.isIncomeRecord {
                        list.append(HistoryInfo(id: index,
                                                title: balanceInfo.incomeCategory ?? "",
                                                type: .income,
                                                date: balanceInfo.date ?? "",
                                                amount: "\(balanceInfo.amount ?? .zero)"))
                    } else if balanceInfo.isExpenseRecord {
                        list.append(HistoryInfo(id: index,
                                                title: balanceInfo.expenseCategory ?? "",
                                                type: .expenses,
                                                date: balanceInfo.date ?? "",
                                                amount: "\(balanceInfo.amount ?? .zero)"))
                    }
                } catch {
                    print("\(error)")
                }
            }
            completion?(list)
        },
                                                 onFailure: {
        })
    }
    
}

#Preview {
    HistoryHomeView()
}
