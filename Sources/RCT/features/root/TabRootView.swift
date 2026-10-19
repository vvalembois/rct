//
//  TabRootView.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

#if os(iOS)
import SwiftUI

/// iPhone layout: native tab bar (Liquid Glass on iOS 26), one navigation stack per tab.
struct TabRootView: View {

    @State private var selection: MenuItem = .network

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                InformationView()
                    .rctCloseToolbar()
            }
            .tabItem { Label(MenuItem.information.title, systemImage: MenuItem.information.systemImage) }
            .tag(MenuItem.information)

            NavigationStack {
                LogListView()
                    .rctCloseToolbar()
            }
            .tabItem { Label(MenuItem.logs.title, systemImage: MenuItem.logs.systemImage) }
            .tag(MenuItem.logs)

            NavigationStack {
                NetworkListView()
                    .rctCloseToolbar()
            }
            .tabItem { Label(MenuItem.network.title, systemImage: MenuItem.network.systemImage) }
            .tag(MenuItem.network)
        }
    }
}
#endif
