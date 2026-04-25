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
                        year: viewModel.selectedYear,
                        month: viewModel.selectedMonth,
                        dailyBalances: viewModel.dailyBalances,
                        onPreviousMonth: {
                            AppLogger.shared.userAction("前月")
                            viewModel.goToPreviousMonth()
                        },
                        onNextMonth: {
                            AppLogger.shared.userAction("次月")
                            viewModel.goToNextMonth()
                        },
                        onSelectYearMonth: { year, month in
                            AppLogger.shared.userAction("年月選択")
                            viewModel.selectYearMonth(year: year, month: month)
                        },
                        availableYearMonths: viewModel.availableYearMonths
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
        .logScreenAppeared()
        .onAppear {
            viewModel.loadMonthlyBalance()
            viewModel.loadDailyBalances(year: viewModel.selectedYear, month: viewModel.selectedMonth)
            viewModel.loadAvailableYearMonths()
        }
        .onChange(of: showingSheetToInputHome) { oldValue, newValue in
            if !newValue {
                viewModel.loadMonthlyBalance()
                viewModel.loadDailyBalances(year: viewModel.selectedYear, month: viewModel.selectedMonth)
            }
        }
    }
    
    func tapPlusButton() {
        AppLogger.shared.userAction("収支入力")
        showingSheetToInputHome = true
    }
}

#Preview {
    TopHomeView()
}
