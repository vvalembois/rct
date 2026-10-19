//
//  LogListView.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

#if os(iOS)
import SwiftUI
import RCTUI

/// iPhone and iPad list of logs, newest first.
///
/// - Without `selection` (iPhone): rows push `LogDetailView`.
/// - With `selection` (iPad split view): rows drive the detail column.
struct LogListView: View {

    @EnvironmentObject private var repository: LogRepository

    @State private var scope: LogScope = .anyLevel
    @State private var query = ""

    private let selection: Binding<LogEntry.ID?>?

    init(selection: Binding<LogEntry.ID?>? = nil) {
        self.selection = selection
    }

    private var logs: [LogEntry] {
        LogFilter.apply(repository.logs, scope: scope, query: query)
    }

    private var exportText: String {
        logs.map { $0.toString() }.joined(separator: "\n")
    }

    var body: some View {
        List(selection: selection) {
            ForEach(logs) { log in
                rowView(for: log)
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if repository.logs.isEmpty {
                DSEmptyState("No Logs", systemImage: MenuItem.logs.systemImage, message: "Messages sent with rct_log will appear here.")
            } else if logs.isEmpty {
                DSEmptyState("No Results", systemImage: "magnifyingglass", message: "No log matches the current search or filter.")
            }
        }
        .searchable(text: $query, prompt: "Message or context")
        .dsNavigationTitle(MenuItem.logs.title, subtitle: repository.logs.count == 1 ? "1 entry" : "\(repository.logs.count) entries")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                DSFilterMenu(selection: $scope, defaultScope: .anyLevel)

                ShareLink(item: exportText) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .disabled(logs.isEmpty)

                Button(role: .destructive) {
                    repository.clear()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .disabled(repository.logs.isEmpty)
            }
        }
    }

    @ViewBuilder
    private func rowView(for log: LogEntry) -> some View {
        if selection != nil {
            LogRow(log: log)
                .tag(log.id)
        } else {
            NavigationLink {
                LogDetailView(log: log)
            } label: {
                LogRow(log: log)
            }
        }
    }
}
#endif
