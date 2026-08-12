//
//  PlatformToolbar.swift
//  RCT
//
//  Created by Vincent on 11/01/2026.
//

import SwiftUI

struct PlatformToolbar<Leading: View, Trailing: View>: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    var navigation: Bool
    var leading: (() -> Leading)
    var trailing: (() -> Trailing)
    
    func body(content: Content) -> some View {
        content.toolbar {
            #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) { leading() }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) { trailing() }
            #elseif os(macOS)
                if navigation {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {dismiss()}) { Image(systemName: "chevron.backward") }
                    }
                }
                
                ToolbarItemGroup(placement: .automatic) {
                    leading()
                    trailing()
                }
            #endif
        }
    }
}

extension View {
    func platformToolbar<Leading: View, Trailing: View>(
        navigation: Bool = false,
        @ViewBuilder navigationBarLeading: @escaping (() -> Leading),
        @ViewBuilder navigationBarTrailing: @escaping (() -> Trailing)
    ) -> some View {
        self.modifier(PlatformToolbar(
            navigation: navigation,
            leading: navigationBarLeading,
            trailing: navigationBarTrailing
        ))
    }
}
