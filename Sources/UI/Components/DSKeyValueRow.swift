//
//  DSKeyValueRow.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// A key/value row for `Form` and `List`, built on `LabeledContent`.
///
/// - `inline`: label leading, value trailing (Settings style), for short values.
/// - `stacked`: label above value, for long values such as URLs or headers.
///
/// The value can always be copied from the context menu.
public struct DSKeyValueRow: View {

    public enum Layout: Sendable {
        case inline
        case stacked
    }

    private let title: String
    private let value: String
    private let tone: DSTone?
    private let layout: Layout
    private let monospaced: Bool

    public init(
        _ title: String,
        value: String,
        tone: DSTone? = nil,
        layout: Layout = .inline,
        monospaced: Bool = false
    ) {
        self.title = title
        self.value = value
        self.tone = tone
        self.layout = layout
        self.monospaced = monospaced
    }

    public var body: some View {
        Group {
            switch layout {
            case .inline:
                LabeledContent(title) {
                    valueText
                        .foregroundStyle(tone?.color ?? Color.secondary)
                        .multilineTextAlignment(.trailing)
                }
            case .stacked:
                VStack(alignment: .leading, spacing: DSSpacing.xxSmall) {
                    Text(title)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    valueText
                        .foregroundStyle(tone?.color ?? Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .accessibilityElement(children: .combine)
            }
        }
        .dsCopyable(value)
    }

    @ViewBuilder
    private var valueText: some View {
        #if os(macOS)
        Text(value)
            .font(monospaced ? .dsCode : .body)
            .textSelection(.enabled)
        #else
        Text(value)
            .font(monospaced ? .dsCode : .body)
        #endif
    }
}

#Preview {
    Form {
        Section("Summary") {
            DSKeyValueRow("Status", value: "201 Created", tone: .success)
            DSKeyValueRow("Duration", value: "1.24 s", tone: .warning)
            DSKeyValueRow("Size", value: "1 KB")
        }
        Section("Headers") {
            DSKeyValueRow("content-type", value: "application/json; charset=utf-8", layout: .stacked, monospaced: true)
        }
    }
    .formStyle(.grouped)
}
