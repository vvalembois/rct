//
//  LogItem.swift
//  RCT
//
//  Created by Vincent on 03/10/2025.
//

import SwiftUI

struct LogItem: View {
    
    let log: LogEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                Image(systemName: log.getImage()).font(.subheadline)
                Text(log.type.rawValue).font(.subheadline)
                
                Spacer()
                
                Text(
                    log.dateFormatter.string(from: Date(timeIntervalSince1970: log.time))
                ).font(.subheadline)
            }
            .foregroundColor(log.getColor())
            
            if !log.className.isEmpty {
                Text(log.className).bold()
            }
            
            Text(log.message)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondarySystemBackground)
        .cornerRadius(20)
    }
}

#Preview {
    VStack(spacing: 20) {
        LogItem(log: LogEntry(type: .info, message: "Hello World", time: Date().timeIntervalSince1970, className: "Preview"))
        
        LogItem(log: LogEntry(type: .warning, message: "Warning", time: Date().timeIntervalSince1970, className: "Preview"))
        
        LogItem(log: LogEntry(type: .error, message: "Error", time: Date().timeIntervalSince1970, className: "Preview"))
    }
    
}
