//
//  PlatformPageTabViewStyle.swift
//  RCT
//
//  Created by Vincent on 11/01/2026.
//


import SwiftUI

struct PlatformPageTabViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        #if os(iOS)
        content.tabViewStyle(.page(indexDisplayMode: .automatic))
        #else
        content.tabViewStyle(.automatic)
        #endif
    }
}

extension View {
    func platformPageTabViewStyle() -> some View {
        self.modifier(PlatformPageTabViewStyle())
    }
}
