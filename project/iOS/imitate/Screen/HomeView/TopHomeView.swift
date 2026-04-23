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
                            AppLogger.shared.buttonTapped("PreviousMonth", on: "TopHomeView")
                            viewModel.goToPreviousMonth()
                        },
                        onNextMonth: {
                            AppLogger.shared.buttonTapped("NextMonth", on: "TopHomeView")
                            viewModel.goToNextMonth()
                        },
                        onSelectYearMonth: { year, month in
                            AppLogger.shared.buttonTapped("SelectYearMonth", on: "TopHomeView")
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
        .onAppear {
            AppLogger.shared.screenAppeared("TopHomeView")
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
        AppLogger.shared.buttonTapped("Plus", on: "TopHomeView")
        showingSheetToInputHome = true
    }
}

#Preview {
    TopHomeView()
}
