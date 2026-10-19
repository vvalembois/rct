//
//  LogDetailView.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI
import RCTUI

/// Detail of a log entry, shared by iPhone (pushed), iPad (detail column) and Mac (inspector).
struct LogDetailView: View {

    let log: LogEntry

    /// When embedded (Mac inspector) the view does not set a navigation title nor toolbar items.
    var isEmbedded = false

    /// Pretty-printed message when the whole message is JSON, `nil` otherwise.
    private var prettyJSON: String? {
        let pretty = log.message.toPretty()
        return pretty == log.message ? nil : pretty
    }

    var body: some View {
        if isEmbedded {
            content
        } else {
            content
                .dsNavigationTitle(log.type.rawValue, subtitle: log.contextText, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        ShareLink(item: log.toString()) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                }
        }
    }

    private var content: some View {
        Form {
            Section {
                DSKeyValueRow("Level", value: log.type.rawValue, tone: log.tone)
                DSKeyValueRow("Context", value: log.contextText)
                DSKeyValueRow("Date", value: DSFormat.dateTime(log.date))
            }

            Section {
                if let prettyJSON {
                    DSCodeBlock(prettyJSON, language: .json)
                } else {
                    Text(log.message)
                        .textSelection(.enabled)
                }
            } header: {
                HStack {
                    Text("Message")
                    Spacer()
                    Button("Copy") {
                        DSPasteboard.copy(log.message)
                    }
                }
                .textCase(nil)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    NavigationStack {
        LogDetailView(log: LogEntry(type: .warning, message: "{\"retry\":2,\"max\":3}", time: Date().timeIntervalSince1970, className: "UserService"))
    }
}
