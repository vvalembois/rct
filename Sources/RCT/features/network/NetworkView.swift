//
//  NetworkView.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import Foundation
import SwiftUI

struct NetworkView: View {
    
    @EnvironmentObject var networkRepository: NetworkRepository
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(networkRepository.calls) { call in
                    NavigationLink(value: call) {
                        NetworkItem(apiCall: call)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical)
        }
        .platformNavigationTitle(MenuItem.network.title)
        #if os(iOS)
        .listStyle(.insetGrouped)
        .platformToolbar(
            navigationBarLeading: {
                Button(
                    action: { RCT.sharedInstance().motionDetected() },
                    label: { Label("Close", systemImage: "xmark") }
                )
            },
            
            navigationBarTrailing: {
                Button {
                    networkRepository.clear()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
            }
        )
        #elseif os(macOS)
        .listStyle(.inset)
        .platformToolbar(
            navigationBarTrailing: {
                Button {
                    networkRepository.clear()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
            }
        )
        #endif
    }
}

#Preview {
    NetworkView()
}
