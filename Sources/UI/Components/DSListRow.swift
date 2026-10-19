//
//  DSListRow.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// Standard two-line list row: optional leading accessory, title (body),
/// subtitle (subheadline, secondary) and optional trailing accessory.
///
/// Use it inside a native `List`: separators, insets, selection and
/// disclosure indicators stay the system ones.
public struct DSListRow<Leading: View, Trailing: View>: View {

    private let title: String
    private let subtitle: String?
    private let titleLineLimit: Int
    private let leading: Leading
    private let trailing: Trailing

    public init(
        title: String,
        subtitle: String? = nil,
        titleLineLimit: Int = 1,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.subtitle = subtitle
        self.titleLineLimit = titleLineLimit
        self.leading = leading()
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(alignment: .center, spacing: DSSpacing.medium) {
            leading

            VStack(alignment: .leading, spacing: DSSpacing.xxSmall) {
                Text(title)
                    .font(.body)
                    .lineLimit(titleLineLimit)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: DSSpacing.small)

            trailing
        }
        .padding(.vertical, DSSpacing.xxSmall)
        .accessibilityElement(children: .combine)
    }
}

public extension DSListRow where Leading == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        titleLineLimit: Int = 1,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.init(title: title, subtitle: subtitle, titleLineLimit: titleLineLimit, leading: { EmptyView() }, trailing: trailing)
    }
}

public extension DSListRow where Trailing == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        titleLineLimit: Int = 1,
        @ViewBuilder leading: () -> Leading
    ) {
        self.init(title: title, subtitle: subtitle, titleLineLimit: titleLineLimit, leading: leading, trailing: { EmptyView() })
    }
}

public extension DSListRow where Leading == EmptyView, Trailing == EmptyView {
    init(title: String, subtitle: String? = nil, titleLineLimit: Int = 1) {
        self.init(title: title, subtitle: subtitle, titleLineLimit: titleLineLimit, leading: { EmptyView() }, trailing: { EmptyView() })
    }
}

#Preview {
    List {
        DSListRow(title: "/v1/users", subtitle: "POST · api.example.com", trailing: {
            DSStatusText("201", tone: .success)
        })
        DSListRow(title: "App started", subtitle: "App · 03:08:02.077", leading: {
            DSToneIcon(.info)
        })
    }
}
