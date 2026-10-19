//
//  NetworkTableView.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

#if os(macOS)
import SwiftUI
import RCTUI

/// Mac table of captured calls with sortable columns and an inspector.
struct NetworkTableView: View {

    @EnvironmentObject private var repository: NetworkRepository

    @State private var selection: ApiCall.ID?
    @State private var sortOrder = [KeyPathComparator(\ApiCall.dateSortKey, order: .reverse)]
    @State private var scope: NetworkScope = .anyStatus
    @State private var query = ""
    @State private var showsInspector = true

    private var calls: [ApiCall] {
        NetworkFilter.apply(repository.calls, scope: scope, query: query).sorted(using: sortOrder)
    }

    private var selectedCall: ApiCall? {
        repository.calls.first { $0.id == selection }
    }

    var body: some View {
        Group {
            if repository.calls.isEmpty {
                DSEmptyState("No Requests", systemImage: MenuItem.network.systemImage, message: "Network calls made by the app will appear here.")
            } else {
                table
            }
        }
        .dsNavigationTitle(MenuItem.network.title, subtitle: NetworkFilter.summary(repository.calls))
        .searchable(text: $query, placement: .toolbar, prompt: "URL, method or status")
        .toolbar {
            ToolbarItem(placement: .principal) {
                DSFilterPicker("Status", selection: $scope)
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button(role: .destructive) {
                    selection = nil
                    repository.clear()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .keyboardShortcut("k", modifiers: .command)
                .disabled(repository.calls.isEmpty)

                Button {
                    showsInspector.toggle()
                } label: {
                    Label("Inspector", systemImage: "sidebar.right")
                }
            }
        }
        .inspector(isPresented: $showsInspector) {
            Group {
                if let selectedCall {
                    NetworkDetailView(call: selectedCall, isEmbedded: true)
                } else {
                    DSEmptyState("No Request Selected", systemImage: MenuItem.network.systemImage, message: "Select a request to inspect it.")
                }
            }
            .inspectorColumnWidth(min: 300, ideal: 380, max: 560)
        }
    }

    private var table: some View {
        Table(calls, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Status", value: \.statusSortKey) { call in
                HStack(spacing: DSSpacing.xSmall) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 7))
                        .foregroundStyle(call.statusTone.color)
                        .accessibilityHidden(true)
                    Text(call.statusCodeText)
                        .monospacedDigit()
                }
            }
            .width(min: 56, ideal: 70, max: 90)

            TableColumn("Method", value: \.method)
                .width(min: 44, ideal: 60, max: 80)

            TableColumn("Host", value: \.host)
                .width(min: 80, ideal: 160)

            TableColumn("Path", value: \.path)
                .width(min: 120, ideal: 260)

            TableColumn("Type", value: \.contentTypeText)
                .width(min: 40, ideal: 60, max: 120)

            TableColumn("Size", value: \.sizeSortKey) { call in
                Text(call.responseSizeText)
                    .monospacedDigit()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .width(min: 50, ideal: 70, max: 100)

            TableColumn("Duration", value: \.durationSortKey) { call in
                Text(call.durationText)
                    .monospacedDigit()
                    .foregroundStyle(call.isSlow ? Color.orange : Color.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .width(min: 60, ideal: 76, max: 100)

            TableColumn("Time", value: \.dateSortKey) { call in
                Text(DSFormat.time(call.requestDate))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            .width(min: 90, ideal: 100, max: 120)
        }
        .contextMenu(forSelectionType: ApiCall.ID.self) { selectedIDs in
            if let call = repository.calls.first(where: { selectedIDs.contains($0.id) }) {
                Button("Copy URL") { DSPasteboard.copy(call.requestURL ?? "") }
                Button("Copy as cURL") { DSPasteboard.copy(call.toCurl()) }
            }
        } primaryAction: { selectedIDs in
            selection = selectedIDs.first
            showsInspector = true
        }
    }
}
#endif
