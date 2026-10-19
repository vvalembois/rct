//
//  MenuItem.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import Foundation

/// Top-level sections of RCT.
enum MenuItem: String, CaseIterable, Identifiable, Hashable {
    case information
    case logs
    case network

    var id: String { rawValue }

    var title: String {
        switch self {
        case .information: return "Information"
        case .logs: return "Logs"
        case .network: return "Network"
        }
    }

    var systemImage: String {
        switch self {
        case .information: return "info.circle"
        case .logs: return "list.bullet.rectangle"
        case .network: return "network"
        }
    }
}
