//
//  DSSyntaxHighlighter.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import Foundation
import SwiftUI

/// Minimal JSON syntax highlighter producing an `AttributedString`
/// colored with system colors (adapts to light and dark mode).
public enum DSSyntaxHighlighter {

    public enum TokenKind: Sendable {
        case key
        case string
        case number
        case literal
    }

    public struct Token: Equatable, Sendable {
        public let kind: TokenKind
        /// Matched text.
        public let text: String
    }

    /// Bodies bigger than this are not highlighted to keep scrolling smooth.
    public static let highlightLimit = 60_000

    /// Lexes `text` and returns the JSON tokens in order.
    public static func jsonTokens(in text: String) -> [Token] {
        matches(in: text).map { Token(kind: $0.kind, text: String(text[$0.range])) }
    }

    /// Returns `text` with JSON keys, strings, numbers and literals colored.
    public static func highlightJSON(_ text: String) -> AttributedString {
        var attributed = AttributedString(text)
        guard text.utf16.count <= highlightLimit else { return attributed }

        for match in matches(in: text) {
            guard let range = Range(match.range, in: attributed) else { continue }
            attributed[range].foregroundColor = color(for: match.kind)
        }
        return attributed
    }

    public static func color(for kind: TokenKind) -> Color {
        switch kind {
        case .key: return .blue
        case .string: return .red
        case .number: return .purple
        case .literal: return .pink
        }
    }

    // MARK: - Lexing

    private struct Match {
        let kind: TokenKind
        let range: Range<String.Index>
    }

    nonisolated(unsafe) private static let regex: NSRegularExpression? = try? NSRegularExpression(
        pattern: #"("(?:[^"\\]|\\.)*")(\s*:)?|(-?\b\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b)|\b(true|false|null)\b"#
    )

    private static func matches(in text: String) -> [Match] {
        guard let regex else { return [] }
        let fullRange = NSRange(text.startIndex..<text.endIndex, in: text)

        return regex.matches(in: text, range: fullRange).compactMap { result in
            if let stringRange = Range(result.range(at: 1), in: text) {
                let isKey = result.range(at: 2).location != NSNotFound
                return Match(kind: isKey ? .key : .string, range: stringRange)
            }
            if let numberRange = Range(result.range(at: 3), in: text) {
                return Match(kind: .number, range: numberRange)
            }
            if let literalRange = Range(result.range(at: 4), in: text) {
                return Match(kind: .literal, range: literalRange)
            }
            return nil
        }
    }
}
