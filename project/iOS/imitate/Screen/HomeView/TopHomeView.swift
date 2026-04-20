//
//  TopHomeView.swift
//  imitate
//
//  Created by garigari0118 on 2025/12/27.
//

import SwiftUI

struct TopHomeView: View {

    @StateObject private var viewModel = TopHomeViewModel()
    @State private var showingSheetToInputHome = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    BalanceView(type: .income, balance: viewModel.monthlyIncome)
                    BalanceView(type: .expenses, balance: viewModel.monthlyExpenses)
                    BalanceGraphView(
                        year: Calendar.current.component(.year, from: Date()),
                        month: Calendar.current.component(.month, from: Date()),
                        dailyBalances: viewModel.dailyBalances
                    )
                    .padding(.vertical, 8)
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
        .sheet(isPresented: $showingSheetToInputHome ) {
            NavigationStack {
                InputHomeView()
            }
            .presentationDetents([.fraction(0.75), .large])
        }
        .onAppear {
            let now = Date()
            let year = Calendar.current.component(.year, from: now)
            let month = Calendar.current.component(.month, from: now)
            viewModel.loadMonthlyBalance()
            viewModel.loadDailyBalances(year: year, month: month)
        }
        .onChange(of: showingSheetToInputHome) { oldValue, newValue in
            if !newValue {
                let now = Date()
                let year = Calendar.current.component(.year, from: now)
                let month = Calendar.current.component(.month, from: now)
                viewModel.loadMonthlyBalance()
                viewModel.loadDailyBalances(year: year, month: month)
            }
        }
    }
    
    func tapPlusButton() {
        showingSheetToInputHome = true
    }
}

#Preview {
    TopHomeView()
}
