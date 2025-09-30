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
                    NavigationLink(destination: NetworkDetailView(apiCall: call)) {
                        NetworkItem(apiCall: call)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemBackground))
        .navigationBarTitle("Network", displayMode: .large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: { RCT.sharedInstance().motionDetected() },
                    label: { Label("Close", systemImage: "xmark") }
                )
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    networkRepository.clear()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
            }
        }
    }
}

#Preview {
    NetworkView()
}
