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
    @Published var isLoading: Bool = false

    private let repository: BalanceRecordRepositoryProtocol

    init(repository: BalanceRecordRepositoryProtocol = BalanceRecordRepository.shared) {
        self.repository = repository
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
