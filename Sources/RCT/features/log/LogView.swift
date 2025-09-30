//
//  LogView.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation
import SwiftUI

struct LogView: View {
    
    @EnvironmentObject var logRepository: LogRepository
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(logRepository.logs) { log in
                    LogItem(log: log)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .listStyle(.plain)
        .navigationBarTitle("Log", displayMode: .large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: { RCT.sharedInstance().motionDetected() },
                    label: { Label("Fermer", systemImage: "xmark") }
                )
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    logRepository.clear()
                } label: {
                    Label("Supprimer", systemImage: "trash")
                }
            }
        }
    }
}
