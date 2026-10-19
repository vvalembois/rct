//
//  LogTableView.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

#if os(macOS)
import SwiftUI
import RCTUI

/// Mac console-like table of logs with sortable columns and an inspector.
struct LogTableView: View {

    @EnvironmentObject private var repository: LogRepository

    @State private var selection: LogEntry.ID?
    @State private var sortOrder = [KeyPathComparator(\LogEntry.time, order: .reverse)]
    @State private var scope: LogScope = .anyLevel
    @State private var query = ""
    @State private var showsInspector = true

    private var logs: [LogEntry] {
        LogFilter.apply(repository.logs, scope: scope, query: query).sorted(using: sortOrder)
    }

    private var selectedLog: LogEntry? {
        repository.logs.first { $0.id == selection }
    }

    private var exportText: String {
        logs.map { $0.toString() }.joined(separator: "\n")
    }

    var body: some View {
        Group {
            if repository.logs.isEmpty {
                DSEmptyState("No Logs", systemImage: MenuItem.logs.systemImage, message: "Messages sent with rct_log will appear here.")
            } else {
                table
            }
        }
        .dsNavigationTitle(MenuItem.logs.title, subtitle: repository.logs.count == 1 ? "1 entry" : "\(repository.logs.count) entries")
        .searchable(text: $query, placement: .toolbar, prompt: "Message or context")
        .toolbar {
            ToolbarItem(placement: .principal) {
                DSFilterPicker("Level", selection: $scope)
            }
            ToolbarItemGroup(placement: .primaryAction) {
                ShareLink(item: exportText) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .disabled(logs.isEmpty)

                Button(role: .destructive) {
                    selection = nil
                    repository.clear()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .keyboardShortcut("k", modifiers: .command)
                .disabled(repository.logs.isEmpty)

                Button {
                    showsInspector.toggle()
                } label: {
                    Label("Inspector", systemImage: "sidebar.right")
                }
            }
        }
        .inspector(isPresented: $showsInspector) {
            Group {
                if let selectedLog {
                    LogDetailView(log: selectedLog, isEmbedded: true)
                } else {
                    DSEmptyState("No Log Selected", systemImage: MenuItem.logs.systemImage, message: "Select a log entry to see its details.")
                }
            }
            .inspectorColumnWidth(min: 280, ideal: 340, max: 520)
        }
    }

    private var table: some View {
        Table(logs, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Time", value: \.time) { log in
                Text(log.timeText)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            .width(min: 90, ideal: 100, max: 120)

            TableColumn("Level", value: \.levelSortKey) { log in
                Label {
                    Text(log.type.rawValue)
                } icon: {
                    DSToneIcon(log.tone)
                        .imageScale(.small)
                }
            }
            .width(min: 80, ideal: 96, max: 120)

            TableColumn("Context", value: \.contextText)
                .width(min: 70, ideal: 120, max: 200)

            TableColumn("Message", value: \.message) { log in
                Text(log.message)
                    .lineLimit(1)
                    .help(log.message)
            }
        }
        .contextMenu(forSelectionType: LogEntry.ID.self) { selectedIDs in
            if let log = repository.logs.first(where: { selectedIDs.contains($0.id) }) {
                Button("Copy Message") { DSPasteboard.copy(log.message) }
                Button("Copy Line") { DSPasteboard.copy(log.toString()) }
            }
        } primaryAction: { selectedIDs in
            selection = selectedIDs.first
            showsInspector = true
        }
    }
}
#endif
