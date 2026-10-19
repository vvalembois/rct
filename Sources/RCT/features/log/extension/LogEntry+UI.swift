//
//  LogEntry+UI.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

import Foundation
import RCTUI

extension LogEntryType {
    
    var tone: DSTone {
        switch self {
        case .info: return .info
        case .warning: return .warning
        case .error: return .critical
        }
    }
}

extension LogEntry {
    
    var tone: DSTone { type.tone }
    
    var timeText: String { DSFormat.time(date) }
    
    var contextText: String { className.isEmpty ? "App" : className }
    
    /// Sort key for the level column (errors first when descending).
    var levelSortKey: Int {
        switch type {
        case .info: return 0
        case .warning: return 1
        case .error: return 2
        }
    }
}
