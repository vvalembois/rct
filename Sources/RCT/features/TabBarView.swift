//
//  TabBarView.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
        TabView {
            NavigationView {
                InformationView()
            }
            .tabItem { Label("Informations", systemImage: "info.circle") }

            NavigationView {
                LogView()
            }
            .tabItem { Label("Log", systemImage: "doc.plaintext") }
            .environmentObject(LogRepository.shared)
            
            NavigationView {
                NetworkView()
            }
            .tabItem { Label("Network", systemImage: "network") }
            .environmentObject(NetworkRepository.shared)
        }
    }
}
