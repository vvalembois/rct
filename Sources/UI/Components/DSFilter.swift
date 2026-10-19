//
//  DSFilter.swift
//  RCTUI
//
//  Created by Vincent Valembois on 19/10/2026.
//

import SwiftUI

/// A finite set of filter values (status, level…) displayed by
/// `DSFilterMenu` (iPhone / iPad toolbar) or `DSFilterPicker` (macOS toolbar).
public protocol DSScope: Hashable, CaseIterable, Identifiable, Sendable where AllCases: RandomAccessCollection {
    var title: String { get }
}

/// Toolbar filter button opening a menu with a checkmarked list
/// (the same pattern as Mail or Files). The icon is filled when a filter is active.
public struct DSFilterMenu<Scope: DSScope>: View {

    @Binding private var selection: Scope
    private let title: String
    private let defaultScope: Scope

    public init(_ title: String = "Filter", selection: Binding<Scope>, defaultScope: Scope) {
        self.title = title
        self._selection = selection
        self.defaultScope = defaultScope
    }

    public var body: some View {
        Menu {
            Picker(title, selection: $selection) {
                ForEach(Scope.allCases) { scope in
                    Text(scope.title).tag(scope)
                }
            }
            .pickerStyle(.inline)
        } label: {
            Label(
                title,
                systemImage: selection == defaultScope
                    ? "line.3.horizontal.decrease.circle"
                    : "line.3.horizontal.decrease.circle.fill"
            )
        }
    }
}

/// Segmented control version of the filter, for wide toolbars (macOS, iPad).
public struct DSFilterPicker<Scope: DSScope>: View {

    @Binding private var selection: Scope
    private let title: String

    public init(_ title: String = "Filter", selection: Binding<Scope>) {
        self.title = title
        self._selection = selection
    }

    public var body: some View {
        Picker(title, selection: $selection) {
            ForEach(Scope.allCases) { scope in
                Text(scope.title).tag(scope)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .fixedSize()
    }
}
