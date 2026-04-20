//
//  TopHomeViewModel.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/15.
//

import Foundation
import Combine

class TopHomeViewModel: ObservableObject {

    @Published var monthlyIncome: String = "0"
    @Published var monthlyExpenses: String = "0"
    @Published var dailyBalances: [DailyBalance] = []
    @Published var availableYearMonths: [(year: Int, month: Int)] = []
    @Published var isLoading: Bool = false
    @Published var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    private let repository: BalanceRecordRepositoryProtocol

    init(repository: BalanceRecordRepositoryProtocol = BalanceRecordRepository.shared) {
        self.repository = repository
    }

    func loadAvailableYearMonths() {
        repository.getAvailableYearMonths(
            onSuccess: { [weak self] yearMonths in
                let parsed: [(year: Int, month: Int)] = yearMonths.compactMap { str in
                    let parts = str.split(separator: "-")
                    guard parts.count == 2,
                          let year = Int(parts[0]),
                          let month = Int(parts[1]) else { return nil }
                    return (year: year, month: month)
                }
                DispatchQueue.main.async {
                    self?.availableYearMonths = parsed
                }
            },
            onFailure: { [weak self] in
                DispatchQueue.main.async {
                    self?.availableYearMonths = []
                }
            }
        )
    }

    func goToPreviousMonth() {
        guard let currentIndex = availableYearMonths.firstIndex(where: { $0.year == selectedYear && $0.month == selectedMonth }),
              currentIndex > 0 else { return }
        let previous = availableYearMonths[currentIndex - 1]
        selectYearMonth(year: previous.year, month: previous.month)
    }

    func goToNextMonth() {
        guard let currentIndex = availableYearMonths.firstIndex(where: { $0.year == selectedYear && $0.month == selectedMonth }),
              currentIndex < availableYearMonths.count - 1 else { return }
        let next = availableYearMonths[currentIndex + 1]
        selectYearMonth(year: next.year, month: next.month)
    }

    func selectYearMonth(year: Int, month: Int) {
        selectedYear = year
        selectedMonth = month
        loadDailyBalances(year: year, month: month)
    }

    func loadDailyBalances(year: Int, month: Int) {
        repository.getDailyBalanceData(
            year: year,
            month: month,
            onSuccess: { [weak self] data in
                let balances: [DailyBalance] = data.compactMap { item in
                    guard let dateStr = item["date"] as? String,
                          let date = DateFormatter.yyyyMMdd.date(from: dateStr),
                          let income = item["cumulativeIncome"] as? Int,
                          let expenses = item["cumulativeExpenses"] as? Int else { return nil }
                    return DailyBalance(
                        date: date,
                        cumulativeIncome: Double(income),
                        cumulativeExpenses: Double(expenses)
                    )
                }
                DispatchQueue.main.async {
                    self?.dailyBalances = balances
                }
            },
            onFailure: { [weak self] in
                DispatchQueue.main.async {
                    self?.dailyBalances = []
                }
            }
        )
    }

    func loadMonthlyBalance() {
        isLoading = true

        repository.getMonthlyIncome(
            onSuccess: { [weak self] income in
                DispatchQueue.main.async {
                    self?.monthlyIncome = "\(income)"
                }
            },
            onFailure: { [weak self] in
                DispatchQueue.main.async {
                    self?.monthlyIncome = "0"
                }
            }
        )

        repository.getMonthlyExpenses(
            onSuccess: { [weak self] expenses in
                DispatchQueue.main.async {
                    self?.monthlyExpenses = "\(expenses)"
                    self?.isLoading = false
                }
            },
            onFailure: { [weak self] in
                DispatchQueue.main.async {
                    self?.monthlyExpenses = "0"
                    self?.isLoading = false
                }
            }
        )
    }
}
