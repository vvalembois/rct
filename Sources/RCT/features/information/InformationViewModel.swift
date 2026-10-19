//
//  InformationViewModel.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation
import RCTUI

#if os(iOS)
import UIKit
#endif

struct InformationRow: Identifiable {
    let title: String
    let value: String
    var id: String { title }
}

struct InformationSection: Identifiable {
    let title: String
    let rows: [InformationRow]
    var id: String { title }
}

@MainActor
final class InformationViewModel: ObservableObject {

    @Published private(set) var sections: [InformationSection] = []

    init() {
        sections = Self.makeSections()
    }

    var maskedKeys: String {
        let keys = NetworkManager.shared.sensitiveKeys
        return keys.isEmpty ? "None" : keys.joined(separator: ", ")
    }

    /// Plain-text report shared from the toolbar.
    var report: String {
        sections
            .map { section in
                ([section.title] + section.rows.map { "\($0.title): \($0.value)" }).joined(separator: "\n")
            }
            .joined(separator: "\n\n")
    }

    private static func makeSections() -> [InformationSection] {
        let info = Bundle.main.infoDictionary ?? [:]
        let name = (info["CFBundleDisplayName"] as? String) ?? (info["CFBundleName"] as? String) ?? DSFormat.placeholder
        let version = (info["CFBundleShortVersionString"] as? String) ?? DSFormat.placeholder
        let build = (info["CFBundleVersion"] as? String) ?? DSFormat.placeholder

        var sections = [
            InformationSection(title: "Application", rows: [
                InformationRow(title: "Name", value: name),
                InformationRow(title: "Version", value: "\(version) (\(build))"),
                InformationRow(title: "Bundle ID", value: Bundle.main.bundleIdentifier ?? DSFormat.placeholder)
            ])
        ]

        #if os(iOS)
        let device = UIDevice.current
        sections.append(InformationSection(title: "Device", rows: [
            InformationRow(title: "Name", value: device.name),
            InformationRow(title: "System", value: "\(device.systemName) \(device.systemVersion)"),
            InformationRow(title: "Model", value: UIDevice.modelName),
            InformationRow(title: "Locale", value: Locale.current.identifier)
        ]))
        #elseif os(macOS)
        let process = ProcessInfo.processInfo
        sections.append(InformationSection(title: "Mac", rows: [
            InformationRow(title: "Name", value: process.hostName),
            InformationRow(title: "System", value: "macOS \(process.operatingSystemVersionString)"),
            InformationRow(title: "Model", value: hardwareModel()),
            InformationRow(title: "Locale", value: Locale.current.identifier)
        ]))
        #endif

        return sections
    }

    #if os(macOS)
    private static func hardwareModel() -> String {
        var size = 0
        guard sysctlbyname("hw.model", nil, &size, nil, 0) == 0, size > 0 else { return DSFormat.placeholder }
        var buffer = [CChar](repeating: 0, count: size)
        guard sysctlbyname("hw.model", &buffer, &size, nil, 0) == 0 else { return DSFormat.placeholder }
        let bytes = buffer.prefix { $0 != 0 }.map { UInt8(bitPattern: $0) }
        return String(bytes: bytes, encoding: .utf8) ?? DSFormat.placeholder
    }
    #endif
}
