//
//  RootView.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// Entry point of the RCT interface.
///
/// - iPhone (compact width): `TabView`, one `NavigationStack` per tab.
/// - iPad (regular width): three-column `NavigationSplitView`.
/// - Mac: `NavigationSplitView` with sortable tables and an inspector.
struct RootView: View {

    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    var body: some View {
        content
            .environmentObject(LogRepository.shared)
            .environmentObject(NetworkRepository.shared)
            #if os(iOS)
            // Keeps RCT in sync when the sheet is dismissed with a swipe.
            .onDisappear { RCT.sharedInstance().didDismiss() }
            #endif
    }

    @ViewBuilder
    private var content: some View {
        #if os(iOS)
        if horizontalSizeClass == .regular {
            SplitRootView()
        } else {
            TabRootView()
        }
        #else
        MacRootView()
        #endif
    }
}

#if os(iOS)
/// Close button of the RCT sheet, placed with the system cancellation role.
struct CloseToolbar: ViewModifier {

    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    RCT.sharedInstance().hideRCT()
                } label: {
                    Label("Close", systemImage: "xmark")
                }
            }
        }
    }
}

extension View {
    func rctCloseToolbar() -> some View {
        modifier(CloseToolbar())
    }
}
#endif
