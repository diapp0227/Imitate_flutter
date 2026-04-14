//
//  HistoryInfoMapperTests.swift
//  imitateTests
//
//  Created by garigari0118 on 2026/04/07.
//

import XCTest
@testable import imitate

/// HistoryInfoMapper のユニットテストクラス
final class HistoryInfoMapperTests: XCTestCase {

    // MARK: - Properties

    var mapper: HistoryInfoMapper!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        mapper = HistoryInfoMapper()
    }

    override func tearDown() {
        mapper = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    /// 空のレコードリストをマッピングした場合、空の配列を返すことをテスト
    func test_空のレコードリストをマッピングした場合_空の配列を返す() {
        // Given
        let emptyRecords: [[String: Any]]? = []

        // When
        let result = mapper.map(emptyRecords)

        // Then
        XCTAssertTrue(result.isEmpty, "空のレコードリストは空の配列を返すべき")
    }

    /// nil のレコードリストをマッピングした場合、空の配列を返すことをテスト
    func test_nilのレコードリストをマッピングした場合_空の配列を返す() {
        // Given
        let nilRecords: [[String: Any]]? = nil

        // When
        let result = mapper.map(nilRecords)

        // Then
        XCTAssertTrue(result.isEmpty, "nil のレコードリストは空の配列を返すべき")
    }

    /// 収入レコードを正しくマッピングできることをテスト
    func test_収入レコードを正しくマッピングできる() {
        // Given
        let incomeRecord: [[String: Any]] = [
            [
                "type": "income",
                "income_category": "給料",
                "amount": 300000,
                "date": "2026-04-01",
                "memo": "4月分の給料",
                "created_at": "2026-04-01 10:00:00",
                "game_flag": 0
            ]
        ]

        // When
        let result = mapper.map(incomeRecord)

        // Then
        XCTAssertEqual(result.count, 1, "1つのレコードをマッピングすべき")
        XCTAssertEqual(result[0].id, 0, "ID は 0 であるべき")
        XCTAssertEqual(result[0].title, "給料", "タイトルは '給料' であるべき")
        XCTAssertEqual(result[0].type, .income, "タイプは income であるべき")
        XCTAssertEqual(result[0].date, "2026-04-01", "日付は '2026-04-01' であるべき")
        XCTAssertEqual(result[0].amount, "300000", "金額は '300000' であるべき")
    }

    /// 支出レコードを正しくマッピングできることをテスト
    func test_支出レコードを正しくマッピングできる() {
        // Given
        let expenseRecord: [[String: Any]] = [
            [
                "type": "expense",
                "expense_category": "食費",
                "amount": 5000,
                "date": "2026-04-02",
                "memo": "ランチ代",
                "created_at": "2026-04-02 12:30:00",
                "game_flag": 0
            ]
        ]

        // When
        let result = mapper.map(expenseRecord)

        // Then
        XCTAssertEqual(result.count, 1, "1つのレコードをマッピングすべき")
        XCTAssertEqual(result[0].id, 0, "ID は 0 であるべき")
        XCTAssertEqual(result[0].title, "食費", "タイトルは '食費' であるべき")
        XCTAssertEqual(result[0].type, .expenses, "タイプは expenses であるべき")
        XCTAssertEqual(result[0].date, "2026-04-02", "日付は '2026-04-02' であるべき")
        XCTAssertEqual(result[0].amount, "5000", "金額は '5000' であるべき")
    }

    /// 複数のレコード（収入と支出の混在）を正しくマッピングできることをテスト
    func test_複数のレコード_収入と支出の混在_を正しくマッピングできる() {
        // Given
        let mixedRecords: [[String: Any]] = [
            [
                "type": "income",
                "income_category": "給料",
                "amount": 300000,
                "date": "2026-04-01",
                "memo": "4月分の給料",
                "created_at": "2026-04-01 10:00:00",
                "game_flag": 0
            ],
            [
                "type": "expense",
                "expense_category": "食費",
                "amount": 5000,
                "date": "2026-04-02",
                "memo": "ランチ代",
                "created_at": "2026-04-02 12:30:00",
                "game_flag": 0
            ],
            [
                "type": "expense",
                "expense_category": "交通費",
                "amount": 2000,
                "date": "2026-04-03",
                "memo": "電車代",
                "created_at": "2026-04-03 08:00:00",
                "game_flag": 0
            ]
        ]

        // When
        let result = mapper.map(mixedRecords)

        // Then
        XCTAssertEqual(result.count, 3, "3つのレコードをマッピングすべき")

        // 1つ目（収入）
        XCTAssertEqual(result[0].id, 0)
        XCTAssertEqual(result[0].title, "給料")
        XCTAssertEqual(result[0].type, .income)

        // 2つ目（支出）
        XCTAssertEqual(result[1].id, 1)
        XCTAssertEqual(result[1].title, "食費")
        XCTAssertEqual(result[1].type, .expenses)

        // 3つ目（支出）
        XCTAssertEqual(result[2].id, 2)
        XCTAssertEqual(result[2].title, "交通費")
        XCTAssertEqual(result[2].type, .expenses)
    }

    /// 不正なレコード（パースエラー）はスキップされることをテスト
    func test_不正なレコード_パースエラー_はスキップされる() {
        // Given
        let invalidRecords: [[String: Any]] = [
            [
                "type": "income",
                "income_category": "給料",
                "amount": 300000,
                "date": "2026-04-01"
            ],
            [
                "invalid_key": "invalid_value"  // 不正なデータ
            ],
            [
                "type": "expense",
                "expense_category": "食費",
                "amount": 5000,
                "date": "2026-04-02"
            ]
        ]

        // When
        let result = mapper.map(invalidRecords)

        // Then
        XCTAssertEqual(result.count, 2, "不正なレコードはスキップされ、2つのレコードのみマッピングされるべき")
        XCTAssertEqual(result[0].title, "給料")
        XCTAssertEqual(result[1].title, "食費")
    }

    /// カテゴリが空のレコードはスキップされることをテスト
    func test_カテゴリが空のレコードはスキップされる() {
        // Given
        let emptyCategoryRecords: [[String: Any]] = [
            [
                "type": "income",
                "income_category": "",  // 空のカテゴリ
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

        // When
        let result = mapper.map(emptyCategoryRecords)

        // Then
        XCTAssertEqual(result.count, 1, "空のカテゴリはスキップされ、1つのレコードのみマッピングされるべき")
        XCTAssertEqual(result[0].title, "食費")
    }

    /// nil の値を持つフィールドがデフォルト値にフォールバックすることをテスト
    func test_nilの値を持つフィールドがデフォルト値にフォールバックする() {
        // Given
        let recordWithNilValues: [[String: Any]] = [
            [
                "type": "income",
                "income_category": "給料"
                // amount, date などは nil（辞書に含まれない）
            ]
        ]

        // When
        let result = mapper.map(recordWithNilValues)

        // Then
        XCTAssertEqual(result.count, 1, "1つのレコードをマッピングすべき")
        XCTAssertEqual(result[0].title, "給料")
        XCTAssertEqual(result[0].date, "", "日付が nil の場合、空文字列にフォールバックすべき")
        XCTAssertEqual(result[0].amount, "0", "金額が nil の場合、'0' にフォールバックすべき")
    }
}
