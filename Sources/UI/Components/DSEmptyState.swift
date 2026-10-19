//
//  DSEmptyState.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// Empty / no-selection state. Uses `ContentUnavailableView` when available
/// and falls back to an equivalent layout on iOS 16.
public struct DSEmptyState: View {

    private let title: String
    private let systemImage: String
    private let message: String?

    public init(_ title: String, systemImage: String, message: String? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.message = message
    }

    public var body: some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            ContentUnavailableView {
                Label(title, systemImage: systemImage)
            } description: {
                if let message {
                    Text(message)
                }
            }
        } else {
            VStack(spacing: DSSpacing.small) {
                Image(systemName: systemImage)
                    .font(.system(size: 44))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, DSSpacing.xSmall)
                Text(title)
                    .font(.title2.bold())
                if let message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(DSSpacing.xxLarge)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    DSEmptyState("No Requests", systemImage: "network", message: "Network calls made by the app will appear here.")
}
