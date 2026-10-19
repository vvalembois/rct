//
//  DSCodeBlock.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// Monospaced, selectable block for payloads (JSON, XML, plain text).
///
/// Long lines scroll horizontally instead of wrapping so the structure
/// of the payload is preserved. Very large payloads are truncated for
/// display only: copy actions should use the full original value.
public struct DSCodeBlock: View {

    public enum Language: Sendable {
        case json
        case plain
    }

    /// Characters displayed before truncation.
    public static let displayLimit = 100_000

    private let content: AttributedString
    private let isTruncated: Bool

    public init(_ code: String, language: Language = .plain) {
        let truncated = code.count > Self.displayLimit
        let visible = truncated ? String(code.prefix(Self.displayLimit)) : code

        switch language {
        case .json:
            self.content = DSSyntaxHighlighter.highlightJSON(visible)
        case .plain:
            self.content = AttributedString(visible)
        }
        self.isTruncated = truncated
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.small) {
            ScrollView(.horizontal, showsIndicators: false) {
                Text(content)
                    .font(.dsCode)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.vertical, DSSpacing.xSmall)
            }

            if isTruncated {
                Label("Truncated for display. Copy to get the full content.", systemImage: "scissors")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    Form {
        Section("Body") {
            DSCodeBlock("{\n  \"id\": 42,\n  \"name\": \"John Appleseed\",\n  \"verified\": false\n}", language: .json)
        }
    }
    .formStyle(.grouped)
}
