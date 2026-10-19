//
//  LogScope.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

import Foundation
import RCTUI

/// Level filter of the logs screen.
enum LogScope: String, DSScope {
    case anyLevel
    case info
    case warning
    case error

    var id: String { rawValue }

    var title: String {
        switch self {
        case .anyLevel: return "All"
        case .info: return "Info"
        case .warning: return "Warning"
        case .error: return "Error"
        }
    }

    func matches(_ log: LogEntry) -> Bool {
        switch self {
        case .anyLevel: return true
        case .info: return log.type == .info
        case .warning: return log.type == .warning
        case .error: return log.type == .error
        }
    }
}

enum LogFilter {

    /// Filters logs by level and search text (message or context), newest first.
    static func apply(_ logs: [LogEntry], scope: LogScope, query: String) -> [LogEntry] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return logs
            .filter { scope.matches($0) }
            .filter { log in
                trimmed.isEmpty
                    || log.message.localizedCaseInsensitiveContains(trimmed)
                    || log.contextText.localizedCaseInsensitiveContains(trimmed)
            }
            .sorted { $0.time > $1.time }
    }
}
