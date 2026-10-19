//
//  NetworkDetailView.swift
//  RCT
//
//  Created by Vincent on 02/10/2025.
//

import SwiftUI
import RCTUI

/// Detail of a captured call, shared by iPhone (pushed), iPad (detail column)
/// and Mac (inspector, `isEmbedded`).
struct NetworkDetailView: View {

    enum DetailTab: String, CaseIterable, Identifiable {
        case overview
        case request
        case response

        var id: String { rawValue }

        var title: String {
            switch self {
            case .overview: return "Overview"
            case .request: return "Request"
            case .response: return "Response"
            }
        }
    }

    let call: ApiCall

    /// When embedded (Mac inspector) the view does not set a navigation title nor toolbar items.
    var isEmbedded = false

    @State private var selectedTab: DetailTab = .overview

    var body: some View {
        if isEmbedded {
            content
        } else {
            content
                .dsNavigationTitle("\(call.method) \(call.path)", subtitle: call.host, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        shareMenu
                    }
                }
        }
    }

    private var content: some View {
        Form {
            Section {
                Picker("Section", selection: $selectedTab) {
                    ForEach(DetailTab.allCases) { detailTab in
                        Text(detailTab.title).tag(detailTab)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            } header: {
                if isEmbedded {
                    embeddedHeader
                }
            }

            switch selectedTab {
            case .overview:
                NetworkOverviewSections(call: call)
            case .request:
                NetworkMessageSections(
                    headers: call.requestHeaders,
                    bodyText: call.requestBody,
                    type: call.requestShortType,
                    contentType: call.requestType
                )
            case .response:
                NetworkMessageSections(
                    headers: call.responseHeaders,
                    bodyText: call.responseBody,
                    type: call.responseShortType,
                    contentType: call.responseType
                )
            }
        }
        .formStyle(.grouped)
    }

    private var embeddedHeader: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: DSSpacing.xxSmall) {
                Text("\(call.method) \(call.path)")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                Text(call.host)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            shareMenu
                .menuStyle(.button)
                .buttonStyle(.borderless)
                .fixedSize()
        }
        .textCase(nil)
        .padding(.bottom, DSSpacing.small)
    }

    private var shareMenu: some View {
        Menu {
            Button {
                DSPasteboard.copy(call.toCurl())
            } label: {
                Label("Copy as cURL", systemImage: "terminal")
            }
            Button {
                DSPasteboard.copy(call.requestURL ?? "")
            } label: {
                Label("Copy URL", systemImage: "link")
            }
            Divider()
            ShareLink(item: call.toCurl()) {
                Label("Share cURL", systemImage: "square.and.arrow.up")
            }
            ShareLink(item: call.toFullLogString()) {
                Label("Share Full Log", systemImage: "doc.text")
            }
        } label: {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }
}

// MARK: - Overview

private struct NetworkOverviewSections: View {

    let call: ApiCall

    var body: some View {
        Section {
            DSKeyValueRow("Status", value: call.statusDescription, tone: call.statusTone)
            DSKeyValueRow("Method", value: call.method)
            DSKeyValueRow("Duration", value: call.durationText, tone: call.isSlow ? .warning : nil)
            DSKeyValueRow("Response Size", value: call.responseSizeText)
            DSKeyValueRow("Content Type", value: call.responseType ?? DSFormat.placeholder)
        }

        Section("URL") {
            Text(call.requestURL ?? DSFormat.placeholder)
                .font(.dsCode)
                .textSelection(.enabled)
                .dsCopyable(call.requestURL ?? "", title: "Copy URL")
        }

        if let queryItems = call.requestURLQueryItems, !queryItems.isEmpty {
            Section("Query") {
                ForEach(Array(queryItems.enumerated()), id: \.offset) { _, item in
                    DSKeyValueRow(item.name, value: item.value ?? "", layout: .stacked, monospaced: true)
                }
            }
        }

        Section("Timing") {
            DSKeyValueRow("Started", value: DSFormat.dateTime(call.requestDate))
            DSKeyValueRow("Ended", value: DSFormat.dateTime(call.responseDate))
            DSKeyValueRow("Timeout", value: call.requestTimeout.map { "\($0) s" } ?? DSFormat.placeholder)
            DSKeyValueRow("Cache Policy", value: call.requestCachePolicy ?? DSFormat.placeholder)
        }

        if let error = call.errorDescription {
            Section("Error") {
                Label {
                    Text(error)
                        .textSelection(.enabled)
                } icon: {
                    DSToneIcon(.critical)
                }
            }
        }
    }
}

// MARK: - Request / Response

private struct NetworkMessageSections: View {

    private struct Header: Identifiable {
        let key: String
        let value: String
        var id: String { key }
    }

    let headers: [String: String]?
    let bodyText: String?
    let type: ApiCallType?
    let contentType: String?

    @State private var showsRaw = false

    private var sensitiveKeys: [String] { NetworkManager.shared.sensitiveKeys }

    private var sortedHeaders: [Header] {
        (headers ?? [:])
            .maskingSensitiveKeys(sensitiveKeys)
            .map { Header(key: $0.key, value: $0.value) }
            .sorted { $0.key.localizedCaseInsensitiveCompare($1.key) == .orderedAscending }
    }

    private var maskedBody: String {
        (bodyText ?? "").maskingSensitiveKeys(sensitiveKeys)
    }

    private var bodyType: ApiCallType { type ?? .OTHER }

    var body: some View {
        Section {
            if sortedHeaders.isEmpty {
                Text("No Headers")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(sortedHeaders) { header in
                    DSKeyValueRow(header.key, value: header.value, layout: .stacked, monospaced: true)
                }
            }
        } header: {
            Text(sortedHeaders.isEmpty ? "Headers" : "Headers (\(sortedHeaders.count))")
        }

        Section {
            if maskedBody.isEmpty {
                Text("No Body")
                    .foregroundStyle(.secondary)
            } else {
                bodyContent
            }
        } header: {
            HStack {
                Text(contentType.map { "Body · \($0)" } ?? "Body")
                Spacer()
                if !maskedBody.isEmpty {
                    if bodyType == .JSON || bodyType == .HTML {
                        Button(showsRaw ? (bodyType == .HTML ? "Preview" : "Pretty") : "Raw") {
                            showsRaw.toggle()
                        }
                    }
                    Button("Copy") {
                        DSPasteboard.copy(maskedBody)
                    }
                }
            }
            .textCase(nil)
        }
    }

    @ViewBuilder
    private var bodyContent: some View {
        switch bodyType {
        case .JSON:
            if showsRaw {
                DSCodeBlock(maskedBody)
            } else {
                DSCodeBlock(maskedBody.toPretty(), language: .json)
            }
        case .HTML:
            if showsRaw {
                DSCodeBlock(maskedBody)
            } else {
                DSWebView(html: maskedBody)
                    .frame(minHeight: 420)
                    .listRowInsets(EdgeInsets())
            }
        case .IMAGE:
            if let image = maskedBody.toImage() {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 360)
            } else {
                Text("Unable to decode the image.")
                    .foregroundStyle(.secondary)
            }
        case .XML, .OTHER:
            DSCodeBlock(maskedBody)
        }
    }
}

#Preview {
    NavigationStack {
        NetworkDetailView(call: ApiCall(
            requestURL: "https://api.example.com/v1/users?page=1",
            requestMethod: "POST",
            requestDate: Date(),
            requestHeaders: ["Content-Type": "application/json", "Authorization": "Bearer token"],
            requestBody: "{\"name\":\"John\"}",
            requestType: "application/json",
            requestShortType: .JSON,
            responseStatus: 201,
            responseDate: Date(),
            responseHeaders: ["Content-Type": "application/json"],
            responseBodyLength: 214,
            responseBody: "{\"id\":42,\"name\":\"John\",\"verified\":false}",
            responseType: "application/json",
            responseShortType: .JSON,
            timeInterval: 1.24,
            noResponse: false
        ))
    }
}
