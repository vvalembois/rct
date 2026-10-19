//
//  MacRootView.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

#if os(macOS)
import SwiftUI

/// Mac layout: source-list sidebar and a detail area hosting tables with an inspector.
struct MacRootView: View {

    @EnvironmentObject private var logRepository: LogRepository
    @EnvironmentObject private var networkRepository: NetworkRepository

    @State private var section: MenuItem? = .network

    var body: some View {
        NavigationSplitView {
            List(selection: $section) {
                Section("RCT") {
                    ForEach(MenuItem.allCases) { item in
                        Label(item.title, systemImage: item.systemImage)
                            .badge(badge(for: item))
                            .tag(item)
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 210, max: 280)
        } detail: {
            switch section ?? .network {
            case .information:
                InformationView()
            case .logs:
                LogTableView()
            case .network:
                NetworkTableView()
            }
        }
        .frame(minWidth: 820, minHeight: 520)
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
