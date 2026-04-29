//
//  CategoryInfo.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/29.
//

import Foundation

enum CategoryType: String, Codable {
    case income = "income"
    case expense = "expense"
}

struct CategoryInfo: Codable {
    /// カテゴリID
    var id: Int?
    /// カテゴリ名
    var name: String?
    /// 種類
    var type: CategoryType?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(CategoryType.self, forKey: .type)
    }

    static func parse(dictionary: [String: Any]) throws -> CategoryInfo? {
        try dictionary.decode(self)
    }
}
