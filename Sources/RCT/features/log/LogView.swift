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
        .platformNavigationTitle(MenuItem.logs.title)
        #if os(iOS)
        .platformToolbar(
            navigationBarLeading: {
                Button {
                    RCT.sharedInstance().motionDetected()
                } label: {
                    Label("Close", systemImage: "xmark")
                }
            },
            navigationBarTrailing: {
                clearButton
            }
        )
        #elseif os(macOS)
        .platformToolbar(
            navigationBarTrailing: {
                clearButton
            }
        )
        #endif
    }
    
    var clearButton: some View {
        Button {
            logRepository.clear()
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
