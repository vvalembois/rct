//
//  DSCatalogView.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// Living catalog of the design system, used in Xcode previews to check
/// every token and component in light, dark and Dynamic Type sizes.
public struct DSCatalogView: View {

    public init() {}

    public var body: some View {
        Form {
            Section("Tones") {
                ForEach(DSTone.allCases, id: \.self) { tone in
                    Label {
                        Text(tone.rawValue.capitalized)
                    } icon: {
                        DSToneIcon(tone)
                            .imageScale(.large)
                    }
                }
            }

            Section("Status") {
                DSListRow(title: "/v1/users", subtitle: "POST · api.example.com · 03:08:12", trailing: {
                    VStack(alignment: .trailing, spacing: DSSpacing.xxSmall) {
                        DSStatusText("201", tone: .success)
                        Text(DSFormat.duration(1.24))
                            .font(.footnote.monospacedDigit())
                            .foregroundStyle(Color.orange)
                    }
                })
                DSListRow(title: "/data", subtitle: "GET · api.exemple.com · 03:08:40", trailing: {
                    DSStatusText("Failed", tone: .critical)
                })
            }

            Section("Key / value") {
                DSKeyValueRow("Status", value: DSFormat.httpStatus(201), tone: .success)
                DSKeyValueRow("Size", value: DSFormat.byteCount(1_214))
                DSKeyValueRow("content-type", value: "application/json", layout: .stacked, monospaced: true)
            }

            Section("Code") {
                DSCodeBlock("{\n  \"id\": 42,\n  \"name\": \"John\",\n  \"verified\": false,\n  \"score\": 9.5,\n  \"tags\": null\n}", language: .json)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview("Light") {
    DSCatalogView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    DSCatalogView()
        .preferredColorScheme(.dark)
}

#Preview("Accessibility XL") {
    DSCatalogView()
        .dynamicTypeSize(.accessibility2)
}
