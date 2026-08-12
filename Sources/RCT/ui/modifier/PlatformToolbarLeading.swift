//
//  PlatformToolbarLeading.swift
//  RCT
//
//  Created by Vincent on 11/01/2026.
//

import SwiftUI

struct PlatformToolbarLeading<Leading: View>: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    var navigation: Bool
    var leading: () -> Leading
    
    func body(content: Content) -> some View {
        content.toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarLeading) { leading() }
            #elseif os(macOS)
            if navigation {
                ToolbarItem(placement: .navigation) { Button(action: { dismiss() }) { Image(systemName: "chevron.backward") } }
            }
            ToolbarItem(placement: .automatic) { leading() }
            #endif
        }
    }
}

struct PlatformToolbarTrailing<Trailing: View>: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    var navigation: Bool
    var trailing: () -> Trailing
    
    func body(content: Content) -> some View {
        content.toolbar {
            #if os(iOS)
            ToolbarItemGroup(placement: .navigationBarTrailing) { trailing() }
            #elseif os(macOS)
            if navigation {
                ToolbarItem(placement: .navigation) { Button(action: {dismiss() }) { Image(systemName: "chevron.backward") } }
            }
            ToolbarItem(placement: .automatic) { trailing() }
            #endif
        }
    }
}

extension View {
    func platformToolbar<Leading: View>(
        navigation: Bool = false,
        @ViewBuilder navigationBarLeading: @escaping () -> Leading
    ) -> some View {
        self.modifier(PlatformToolbarLeading(navigation: navigation, leading: navigationBarLeading))
    }

    func platformToolbar<Trailing: View>(
        navigation: Bool = false,
        @ViewBuilder navigationBarTrailing: @escaping () -> Trailing
    ) -> some View {
        self.modifier(PlatformToolbarTrailing(navigation: navigation, trailing: navigationBarTrailing))
    }
}
