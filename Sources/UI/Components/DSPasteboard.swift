//
//  DSPasteboard.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Cross-platform access to the general pasteboard.
public enum DSPasteboard {

    @MainActor
    public static func copy(_ string: String) {
        #if os(iOS)
        UIPasteboard.general.string = string
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(string, forType: .string)
        #endif
    }
}
