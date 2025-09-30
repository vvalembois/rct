//
//  Json+Ext.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import Foundation

public extension Encodable {
    func asJson() -> String {
        if let data = try? JSONEncoder().encode(self), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return ""
    }
}

public extension String {
    func decodeFromJson<T: Decodable>(type: T.Type) -> T? {
        return try? JSONDecoder().decode(T.self, from: self.data(using: .utf8) ?? Data())
    }
}
