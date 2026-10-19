//
//  DSCopyable.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

public extension View {

    /// Adds a native context menu (long press on iOS, right click on macOS)
    /// with a "Copy" action for `text`.
    func dsCopyable(_ text: String, title: String = "Copy") -> some View {
        contextMenu {
            Button {
                DSPasteboard.copy(text)
            } label: {
                Label(title, systemImage: "doc.on.doc")
            }
        }
    }
}
