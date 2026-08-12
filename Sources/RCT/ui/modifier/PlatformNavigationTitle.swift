//
//  PlatformNavigationTitle.swift
//  RCT
//
//  Created by Vincent on 11/01/2026.
//
import SwiftUI

struct PlatformNavigationTitle: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        #if os(iOS)
        content.navigationBarTitle(title, displayMode: .large)
        #else
        content.navigationTitle(title)
        #endif
    }
}

extension View {
    func platformNavigationTitle(_ title: String) -> some View {
        self.modifier(PlatformNavigationTitle(title: title))
    }
}
