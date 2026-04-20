//
//  HistoryHomeViewModelTests.swift
//  imitateTests
//
//  Created by garigari0118 on 2026/04/07.
//

import XCTest
@testable import imitate

/// HistoryHomeViewModel のユニットテストクラス
@MainActor
final class HistoryHomeViewModelTests: XCTestCase {

    // MARK: - Properties

    var viewModel: HistoryHomeViewModel!
    var mockRepository: MockBalanceRecordRepository!
    var mapper: HistoryInfoMapper!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        mockRepository = MockBalanceRecordRepository()
        mapper = HistoryInfoMapper()
        viewModel = HistoryHomeViewModel(repository: mockRepository, mapper: mapper)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mapper = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    /// 初期状態で historyList が空であることをテスト
    func test_初期状態でhistoryListが空である() {
        // Then
        XCTAssertTrue(viewModel.historyList.isEmpty, "初期状態では historyList は空であるべき")
    }

    /// loadHistory が成功した場合、historyList が更新されることをテスト
    func test_loadHistoryが成功した場合_historyListが更新される() async {
        // Given
        let mockRecords: [[String: Any]] = [
            [
                "type": "income",
                "income_category": "給料",
                "amount": 300000,
                "date": "2026-04-01"
            ],
            [
                "type": "expense",
                "expense_category": "食費",
                "amount": 5000,
                "date": "2026-04-02"
            ]
        ]
        mockRepository.mockRecords = mockRecords
        mockRepository.shouldSucceed = true

        // When
        viewModel.loadHistory()

        // Wait for async operations to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒待機

        // Then
        XCTAssertEqual(viewModel.historyList.count, 2, "2つのレコードがマッピングされるべき")
        XCTAssertEqual(viewModel.historyList[0].title, "給料")
        XCTAssertEqual(viewModel.historyList[0].type, .income)
        XCTAssertEqual(viewModel.historyList[1].title, "食費")
        XCTAssertEqual(viewModel.historyList[1].type, .expenses)
    }

    /// loadHistory が失敗した場合、historyList が空になることをテスト
    func test_loadHistoryが失敗した場合_historyListが空になる() async {
        // Given
        mockRepository.shouldSucceed = false

        // 既存のデータを設定
        viewModel.historyList = [
            HistoryHomeView.HistoryInfo(id: 0, title: "Test", type: .income, date: "2026-04-01", amount: "100")
        ]

        // When
        viewModel.loadHistory()

        // Wait for async operations to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒待機

        // Then
        XCTAssertTrue(viewModel.historyList.isEmpty, "失敗時には historyList は空になるべき")
    }

    /// loadHistory で空のレコードを受け取った場合、historyList が空になることをテスト
    func test_loadHistoryで空のレコードを受け取った場合_historyListが空になる() async {
        // Given
        mockRepository.mockRecords = []
        mockRepository.shouldSucceed = true

        // When
        viewModel.loadHistory()

        // Wait for async operations to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒待機

        // Then
        XCTAssertTrue(viewModel.historyList.isEmpty, "空のレコードの場合、historyList は空であるべき")
    }

    /// loadHistory で nil のレコードを受け取った場合、historyList が空になることをテスト
    func test_loadHistoryでnilのレコードを受け取った場合_historyListが空になる() async {
        // Given
        mockRepository.mockRecords = nil
        mockRepository.shouldSucceed = true

        // When
        viewModel.loadHistory()

        // Wait for async operations to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒待機

        // Then
        XCTAssertTrue(viewModel.historyList.isEmpty, "nil のレコードの場合、historyList は空であるべき")
    }

    /// loadHistory が複数回呼ばれた場合、正しく動作することをテスト
    func test_loadHistoryが複数回呼ばれた場合_正しく動作する() async {
        // Given - 1回目
        mockRepository.mockRecords = [
            [
                "type": "income",
                "income_category": "給料",
                "amount": 300000,
                "date": "2026-04-01"
            ]
        ]
        mockRepository.shouldSucceed = true

        // When - 1回目
        viewModel.loadHistory()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then - 1回目
        XCTAssertEqual(viewModel.historyList.count, 1, "1回目のロード後は1つのレコードがあるべき")

        // Given - 2回目
        mockRepository.mockRecords = [
            [
                "type": "expense",
                "expense_category": "食費",
                "amount": 5000,
                "date": "2026-04-02"
            ],
            [
                "type": "expense",
                "expense_category": "交通費",
                "amount": 2000,
                "date": "2026-04-03"
            ]
        ]

        // When - 2回目
        viewModel.loadHistory()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then - 2回目
        XCTAssertEqual(viewModel.historyList.count, 2, "2回目のロード後は2つのレコードに更新されるべき")
        XCTAssertEqual(viewModel.historyList[0].title, "食費")
        XCTAssertEqual(viewModel.historyList[1].title, "交通費")
    }
}

// MARK: - Mock Repository

/// テスト用のモック BalanceRecordRepository
class MockBalanceRecordRepository: BalanceRecordRepositoryProtocol {
    func getAvailableYearMonths(onSuccess: @escaping (([String]) -> Void), onFailure: @escaping (() -> Void)) {
        // TODO: 別途テスト作成
    }
    
    func getDailyBalanceData(year: Int, month: Int, onSuccess: @escaping (([[String : Any]]) -> Void), onFailure: @escaping (() -> Void)) {
        // TODO: 別途テスト作成
    }
    
    func getMonthlyIncome(onSuccess: @escaping ((Int) -> Void), onFailure: @escaping (() -> Void)) {
        // TODO: 別途テスト作成
    }
    
    func getMonthlyExpenses(onSuccess: @escaping ((Int) -> Void), onFailure: @escaping (() -> Void)) {
        // TODO: 別途テスト作成
    }
    

    var mockRecords: [[String: Any]]? = []
    var shouldSucceed: Bool = true
    var selectAllCallCount: Int = 0

    func selectAll(onSuccess: @escaping (([[String : Any]]?) -> Void), onFailure: @escaping (() -> Void)) {
        selectAllCallCount += 1

        if shouldSucceed {
            onSuccess(mockRecords)
        } else {
            onFailure()
        }
    }

    func insertRecord(arguments: [String : Any]) {
        // テストでは使用しないため、実装なし
    }
}
