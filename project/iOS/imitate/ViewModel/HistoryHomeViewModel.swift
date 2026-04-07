//
//  HistoryHomeViewModel.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/07.
//

import Foundation

/// HistoryHomeView のビジネスロジックを管理する ViewModel
@MainActor
class HistoryHomeViewModel: ObservableObject {

    // MARK: - Published Properties

    /// 履歴情報のリスト（UI に自動的に反映される）
    @Published var historyList: [HistoryHomeView.HistoryInfo] = []

    // MARK: - Private Properties

    private let repository: BalanceRecordRepositoryProtocol
    private let mapper: HistoryInfoMapper

    // MARK: - Initializer

    /// イニシャライザ（依存性注入によるテスト容易性の向上）
    /// - Parameters:
    ///   - repository: データ取得を担当するリポジトリ
    ///   - mapper: データ変換を担当するマッパー
    init(
        repository: BalanceRecordRepositoryProtocol = BalanceRecordRepository.shared,
        mapper: HistoryInfoMapper = HistoryInfoMapper()
    ) {
        self.repository = repository
        self.mapper = mapper
    }

    // MARK: - Public Methods

    /// 履歴データを読み込む
    func loadHistory() {
        repository.selectAll(
            onSuccess: { [weak self] records in
                guard let self = self else { return }
                Task { @MainActor in
                    self.historyList = self.mapper.map(records)
                }
            },
            onFailure: {
                // エラー時は空のリストを設定
                Task { @MainActor [weak self] in
                    self?.historyList = []
                }
            }
        )
    }
}
