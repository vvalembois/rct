//
//  Color+Ext.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation
import SwiftUI

extension Color {
    static var systemBackground: Color {
        #if os(iOS)
        Color(uiColor: .systemBackground)
        #elseif os(macOS)
        Color(nsColor: .windowBackgroundColor)
        #endif
    }

    static var secondarySystemBackground: Color {
        #if os(iOS)
        Color(uiColor: .secondarySystemBackground)
        #elseif os(macOS)
        Color(nsColor: .controlBackgroundColor)
        #endif
    }

    static var tertiarySystemBackground: Color {
        #if os(iOS)
        Color(uiColor: .tertiarySystemBackground)
        #elseif os(macOS)
        Color(nsColor: .underPageBackgroundColor)
        #endif
    }

    static var label: Color {
        #if os(iOS)
        Color(uiColor: .label)
        #elseif os(macOS)
        Color(nsColor: .labelColor)
        #endif
    }
}
