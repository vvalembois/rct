//
//  DSToneIcon.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// The SF Symbol of a tone, rendered with a white glyph on the tone color
/// (the same look as the system's status icons). Size it with `.imageScale` or `.font`.
public struct DSToneIcon: View {

    private let tone: DSTone
    private let systemName: String?

    public init(_ tone: DSTone, systemName: String? = nil) {
        self.tone = tone
        self.systemName = systemName
    }

    public var body: some View {
        Image(systemName: systemName ?? tone.symbolName)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, tone.color)
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack {
        ForEach(DSTone.allCases, id: \.self) { DSToneIcon($0) }
    }
    .padding()
}
