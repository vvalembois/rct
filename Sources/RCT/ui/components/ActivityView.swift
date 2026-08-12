//
//  ActivityView.swift
//  RCT
//
//  Created by Vincent on 04/10/2025.
//

import SwiftUI

struct ShareSheet {
    #if os(iOS)
    @MainActor static func share(items: [Any]) {
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        rootVC.present(activityVC, animated: true)
    }
    #endif
    
    #if os(macOS)
    @MainActor static func share(items: [Any]) {
        let picker = NSSharingServicePicker(items: items)
        if let window = NSApplication.shared.keyWindow,
           let contentView = window.contentView {
            picker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
        }
    }
    #endif
}
