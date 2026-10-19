//
//  DSNavigationTitle.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// How the navigation title is displayed on iOS (ignored on macOS).
public enum DSTitleDisplayMode: Sendable {
    case large
    case inline
}

public extension View {

    /// Navigation title with an optional subtitle.
    ///
    /// - iOS 26+: uses the native `navigationSubtitle`.
    /// - Earlier iOS versions: the subtitle is not displayed.
    /// - macOS: the subtitle is the window subtitle.
    @ViewBuilder
    func dsNavigationTitle(
        _ title: String,
        subtitle: String? = nil,
        displayMode: DSTitleDisplayMode = .large
    ) -> some View {
        #if os(iOS)
        let base = navigationTitle(title)
            .navigationBarTitleDisplayMode(displayMode == .large ? .large : .inline)
        if let subtitle {
            #if compiler(>=6.2)
            if #available(iOS 26.0, *) {
                base.navigationSubtitle(subtitle)
            } else {
                base
            }
            #else
            base
            #endif
        } else {
            base
        }
        #else
        if let subtitle {
            navigationTitle(title).navigationSubtitle(subtitle)
        } else {
            navigationTitle(title)
        }
        #endif
    }

    /// `onChange(of:)` that uses the iOS 17 / macOS 14 API when available,
    /// without deprecation warnings on older deployment targets.
    @ViewBuilder
    func dsOnChange<Value: Equatable>(of value: Value, perform action: @escaping (Value) -> Void) -> some View {
        #if os(macOS)
        onChange(of: value) { _, newValue in action(newValue) }
        #else
        if #available(iOS 17.0, *) {
            onChange(of: value) { _, newValue in action(newValue) }
        } else {
            onChange(of: value, perform: action)
        }
        #endif
    }
}
