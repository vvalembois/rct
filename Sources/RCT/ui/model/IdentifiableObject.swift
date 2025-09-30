//
//  IdentifiableObject.swift
//  RCT
//
//  Created by Vincent on 04/10/2025.
//

import Foundation

struct IdentifiableObject: Identifiable {
    let id = UUID()
    let value: Any
}
