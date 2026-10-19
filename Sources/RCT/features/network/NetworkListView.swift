//
//  NetworkListView.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

#if os(iOS)
import SwiftUI
import RCTUI

/// iPhone and iPad list of captured calls.
///
/// - Without `selection` (iPhone): rows push `NetworkDetailView`.
/// - With `selection` (iPad split view): rows drive the detail column.
struct NetworkListView: View {

    @EnvironmentObject private var repository: NetworkRepository

    @State private var scope: NetworkScope = .anyStatus
    @State private var query = ""

    private let selection: Binding<ApiCall.ID?>?

    init(selection: Binding<ApiCall.ID?>? = nil) {
        self.selection = selection
    }

    private var calls: [ApiCall] {
        NetworkFilter.apply(repository.calls, scope: scope, query: query)
    }

    var body: some View {
        List(selection: selection) {
            ForEach(calls) { call in
                rowView(for: call)
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if repository.calls.isEmpty {
                DSEmptyState("No Requests", systemImage: MenuItem.network.systemImage, message: "Network calls made by the app will appear here.")
            } else if calls.isEmpty {
                DSEmptyState("No Results", systemImage: "magnifyingglass", message: "No request matches the current search or filter.")
            }
        }
        .searchable(text: $query, prompt: "URL, method or status")
        .dsNavigationTitle(MenuItem.network.title, subtitle: NetworkFilter.summary(repository.calls))
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                DSFilterMenu(selection: $scope, defaultScope: .anyStatus)

                Button(role: .destructive) {
                    repository.clear()
                } label: {
                    Label("Clear", systemImage: "trash")
                }
                .disabled(repository.calls.isEmpty)
            }
        }
    }

    @ViewBuilder
    private func rowView(for call: ApiCall) -> some View {
        if selection != nil {
            NetworkRow(call: call)
                .tag(call.id)
        } else {
            NavigationLink {
                NetworkDetailView(call: call)
            } label: {
                NetworkRow(call: call)
            }
        }
    }
}
#endif
