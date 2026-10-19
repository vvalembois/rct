//
//  LogRow.swift
//  RCT
//
//  Created by Vincent on 03/10/2025.
//

import SwiftUI
import RCTUI

/// List row of a log entry: level symbol, message (3 lines) and context · time.
struct LogRow: View {

    let log: LogEntry

    var body: some View {
        DSListRow(
            title: log.message,
            subtitle: "\(log.contextText) · \(log.timeText)",
            titleLineLimit: 3,
            leading: {
                DSToneIcon(log.tone)
                    .imageScale(.large)
            }
        )
        .accessibilityLabel("\(log.type.rawValue), \(log.message), \(log.contextText), \(log.timeText)")
        .dsCopyable(log.message)
    }
}

#Preview {
    List {
        LogRow(log: LogEntry(type: .info, message: "App started", time: Date().timeIntervalSince1970, className: "App"))
        LogRow(log: LogEntry(type: .warning, message: "Retrying request (attempt 2 of 3)", time: Date().timeIntervalSince1970, className: "UserService"))
        LogRow(log: LogEntry(type: .error, message: "Decoding failed: keyNotFound(\"message\")", time: Date().timeIntervalSince1970, className: "DogAPI"))
    }
}
