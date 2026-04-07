//
//  InputBalanceSegmentView.swift
//  imitate
//
//  Created by garigari0118 on 2026/01/04.
//

import SwiftUI

struct InputBalanceSegmentView: View {

    enum BalanceType: CaseIterable, Identifiable {
        case income
        case expenses
        
        var id: Self { self }
        
        var name: String {
            switch self {
            case .income:
                "収入"
            case .expenses:
                "支出"
            }
        }
    }
    
    @Binding var selected: BalanceType
    
    var body: some View {
        ZStack{
            Picker("Layout", selection: $selected) {
                ForEach(BalanceType.allCases, id: \.self) { type in
                    Text(type.name)
                }
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
}
