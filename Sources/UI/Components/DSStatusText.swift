//
//  DSStatusText.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// A short status value (HTTP code, level…) colored with its tone.
///
/// The text itself carries the meaning: color is only a reinforcement,
/// so the information stays readable for color-blind users.
public struct DSStatusText: View {

    private let text: String
    private let tone: DSTone

    public init(_ text: String, tone: DSTone) {
        self.text = text
        self.tone = tone
    }

    public var body: some View {
        Text(text)
            .font(.dsMetric)
            .foregroundStyle(tone.color)
    }
}

#Preview {
    VStack(alignment: .leading) {
        DSStatusText("200", tone: .success)
        DSStatusText("304", tone: .notice)
        DSStatusText("404", tone: .warning)
        DSStatusText("500", tone: .critical)
    }
    .padding()
}
