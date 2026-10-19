//
//  LogType.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

public enum LogEntryType: String, Codable, CaseIterable, Sendable {
    case info = "Info"
    case error = "Error"
    case warning = "Warning"
}
