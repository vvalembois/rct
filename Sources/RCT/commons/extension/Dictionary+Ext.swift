//
//  Toto.swift
//  RCT
//
//  Created by Vincent on 09/11/2025.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    /// Returns a copy of the dictionary with values masked
    /// for the provided sensitive keys.
    func maskingSensitiveKeys(_ sensitiveKeys: [String]) -> [String: String] {
        var masked = self
        
        for key in keys {
            if sensitiveKeys.contains(where: { $0.caseInsensitiveCompare(key) == .orderedSame }) {
                masked[key] = "****"
            }
        }
        
        return masked
    }
}
