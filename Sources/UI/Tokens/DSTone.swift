//
//  DSTone.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// Semantic tone used to convey a status (HTTP result, log level…).
///
/// Every tone maps to an Apple **system color** so light/dark mode,
/// Increase Contrast and accessibility settings are handled by the OS.
/// Never hard-code a hex color for a status: pick a tone instead.
public enum DSTone: String, CaseIterable, Sendable {
    case neutral
    case info
    case success
    case notice
    case warning
    case critical

    /// The system color associated with the tone.
    public var color: Color {
        switch self {
        case .neutral: return .secondary
        case .info: return .blue
        case .success: return .green
        case .notice: return .cyan
        case .warning: return .orange
        case .critical: return .red
        }
    }

    /// The SF Symbol associated with the tone (filled variant, two layers).
    public var symbolName: String {
        switch self {
        case .neutral: return "minus.circle.fill"
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .notice: return "arrow.triangle.turn.up.right.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .critical: return "xmark.octagon.fill"
        }
    }
}
