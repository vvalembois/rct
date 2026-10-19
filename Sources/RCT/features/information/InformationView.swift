//
//  InformationView.swift
//
//
//  Created by Vincent Valembois on 28/09/2025.
//

import SwiftUI
import RCTUI

/// App, device and capture settings, in a native grouped form.
struct InformationView: View {

    @StateObject private var viewModel = InformationViewModel()
    @State private var isCapturing = RCT.sharedInstance().started

    var body: some View {
        Form {
            ForEach(viewModel.sections) { section in
                Section(section.title) {
                    ForEach(section.rows) { infoRow in
                        DSKeyValueRow(infoRow.title, value: infoRow.value)
                    }
                }
            }

            Section {
                Toggle("Capture", isOn: $isCapturing)
                DSKeyValueRow("Masked Keys", value: viewModel.maskedKeys)
            } header: {
                Text("Capture")
            } footer: {
                Text("Turning capture off stops recording and clears captured calls. Masked keys are hidden in headers, bodies and exports.")
            }
        }
        .formStyle(.grouped)
        .dsOnChange(of: isCapturing) { isOn in
            if isOn {
                RCT.sharedInstance().start()
            } else {
                RCT.sharedInstance().stop()
            }
        }
        .dsNavigationTitle(MenuItem.information.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: viewModel.report) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        InformationView()
    }
}
