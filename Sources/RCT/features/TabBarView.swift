//
//  TabBarView.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import SwiftUI

enum MenuItem: String, CaseIterable, Identifiable {
    case information
    case logs
    case network

    var id: String { rawValue }

    var title: String {
        switch self {
        case .information: return "Information"
        case .logs: return "Logs"
        case .network: return "Network"
        }
    }

    var icon: String {
        switch self {
        case .information: return "info.circle"
        case .logs: return "doc.plaintext"
        case .network: return "network"
        }
    }
}

#if os(iOS)
struct TabBarView: View {
    
    var body: some View {
        TabView {
            NavigationView {
                InformationView()
            }
            .tabItem { Label(MenuItem.information.title, systemImage: MenuItem.information.icon) }

            NavigationView {
                LogView()
            }
            .tabItem { Label(MenuItem.logs.title, systemImage: MenuItem.logs.icon) }
            .environmentObject(LogRepository.shared)
            
            NavigationView {
                NetworkView()
            }
            .tabItem { Label(MenuItem.network.title, systemImage: MenuItem.network.icon) }
            .environmentObject(NetworkRepository.shared)
        }
    }
}
#elseif os(macOS)
struct SplitView: View {
    
    @State private var selection: MenuItem = .information
    
    @State private var preferredColumn = NavigationSplitViewColumn.sidebar
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List(MenuItem.allCases, selection: $selection) { item in
                Label(item.title, systemImage: item.icon)
                    .tag(item)
            }
            .listStyle(.sidebar)
        } detail: {
            NavigationStack(path: $navigationPath) {
                detailContent
                    .navigationDestination(for: ApiCall.self) { call in
                        NetworkDetailView(apiCall: call)
                    }
            }
        }
    }
    
    @ViewBuilder
    var detailContent: some View {
        switch selection {
        case .logs:
            LogView()
                .environmentObject(LogRepository.shared)
            
        case .network:
            NetworkView()
                .environmentObject(NetworkRepository.shared)
            
        case .information:
            InformationView()
        }
    }
}
#endif 
