//
//  DictionaryExtension.swift
//  imitate
//
//  Created by garigari0118 on 2026/04/07.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func decode<T: Decodable>(_ type: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: self)
        return try decoder.decode(type, from: data)
    }
}
