//
//  DSTypography.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// Typography tokens.
///
/// Text uses the system text styles (`.body`, `.subheadline`, `.footnote`…)
/// so Dynamic Type works everywhere. The only additions are monospaced
/// styles for technical content (bodies, headers, identifiers).
public extension Font {
    /// SF Mono at the footnote size, used for code and payloads.
    static var dsCode: Font { .system(.footnote, design: .monospaced) }

    /// SF Mono at the caption size, used for dense technical values.
    static var dsCodeSmall: Font { .system(.caption, design: .monospaced) }

    /// Subheadline with tabular digits, used for status codes and metrics.
    static var dsMetric: Font { .subheadline.weight(.semibold).monospacedDigit() }
}
