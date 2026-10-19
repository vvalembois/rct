//
//  SplitRootView.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

#if os(iOS)
import SwiftUI
import RCTUI

/// iPad layout: sidebar, list and detail columns.
struct SplitRootView: View {

    @EnvironmentObject private var logRepository: LogRepository
    @EnvironmentObject private var networkRepository: NetworkRepository

    @State private var section: MenuItem? = .network
    @State private var selectedCall: ApiCall.ID?
    @State private var selectedLog: LogEntry.ID?

    var body: some View {
        NavigationSplitView {
            List(selection: $section) {
                ForEach(MenuItem.allCases) { item in
                    Label(item.title, systemImage: item.systemImage)
                        .badge(badge(for: item))
                        .tag(item)
                }
            }
            .navigationTitle("RCT")
            .rctCloseToolbar()
        } content: {
            switch section ?? .network {
            case .information:
                InformationView()
            case .logs:
                LogListView(selection: $selectedLog)
            case .network:
                NetworkListView(selection: $selectedCall)
            }
        } detail: {
            NavigationStack {
                detail
            }
        }
    }

    @ViewBuilder
    private var detail: some View {
        switch section ?? .network {
        case .information:
            DSEmptyState("Information", systemImage: MenuItem.information.systemImage, message: "App and device details are listed on the left.")
        case .logs:
            if let log = logRepository.logs.first(where: { $0.id == selectedLog }) {
                LogDetailView(log: log)
            } else {
                DSEmptyState("No Log Selected", systemImage: MenuItem.logs.systemImage, message: "Select a log entry to see its details.")
            }
        case .network:
            if let call = networkRepository.calls.first(where: { $0.id == selectedCall }) {
                NetworkDetailView(call: call)
            } else {
                DSEmptyState("No Request Selected", systemImage: MenuItem.network.systemImage, message: "Select a request to inspect it.")
            }
        }
    }

    private func badge(for item: MenuItem) -> Int {
        switch item {
        case .information: return 0
        case .logs: return logRepository.logs.count
        case .network: return networkRepository.calls.count
        }
    }
}
#endif
