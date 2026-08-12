//
//  Untitled.swift
//  RCT
//
//  Created by Vincent on 02/10/2025.
//

import SwiftUI

struct NetworkDetailView: View {
    
    @State private var section = 0
    
    @State private var sectionBody = 0
    
    @State private var showOptions = false
    
    let apiCall: ApiCall

    var body: some View {
        VStack {
            Picker("", selection: $section) {
                Text("Information").tag(0)
                Text("Request").tag(1)
                Text("Response").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            switch section {
            case 0:
                infoView
            case 1:
                requestView
            case 2:
                responseView
            default:
                EmptyView()
            }
        }
        #if os(iOS)
        .platformToolbar(
            navigationBarTrailing: {
                exportButton
            }
        )
        #elseif os(macOS)
        .platformToolbar(
            navigation: true,
            navigationBarTrailing: {
                exportButton
            }
        )
        #endif
        
    }
    
    private var exportButton: some View {
        Button(
            action: { showOptions = true },
            label: { Label("Download", systemImage: "square.and.arrow.up") }
        )
        .confirmationDialog(
            "",
            isPresented: $showOptions,
            titleVisibility: .hidden
        ) {
            Button("Curl") {
                ShareSheet.share(items: [IdentifiableObject(value: apiCall.toCurl())])
            }
            Button("Export log") {
                ShareSheet.share(items: [IdentifiableObject(value: apiCall.toFullLogString())])
            }
            Button("Export File log") {
                guard let file = apiCall.toLogFile() else { return }
                ShareSheet.share(items: [IdentifiableObject(value: file)])
            }
            Button("Cancel", role: .cancel) {
                // Cancel action
            }
        }
    }
    
    private var infoView: some View {
        ScrollView {
            VStack(spacing: 20) {
                FieldView(title: "Url", value: apiCall.requestURL ?? "")
                    .fieldStyle()
                
                HStack(spacing: 20) {
                    if let status = apiCall.responseStatus {
                        FieldView(title: "Status", value: "\(status)")
                            .fieldStyle(color: apiCall.getColor())
                            .foregroundStyle(.white)
                    }
                    
                    FieldView(title: "Method", value: apiCall.requestMethod ?? "")
                        .fieldStyle()
                }
                
                FieldView(title: "Request Date", value: apiCall.requestDate?.formatted() ?? "")
                    .fieldStyle()
                
                FieldView(title: "Response Date", value: apiCall.responseDate?.formatted() ?? "")
                    .fieldStyle()
                
                FieldView(title: "Time interval", value: apiCall.timeInterval?.formatted() ?? "")
                    .fieldStyle()
                
                FieldView(title: "Cache policy", value: apiCall.requestCachePolicy ?? "")
                    .fieldStyle()
            }
            .padding()
        }
    }
    
    private var requestView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let headers = apiCall.requestHeaders, !headers.isEmpty {
                    sectionHeader(title: "Headers", fields: headers)
                } else {
                    sectionHeader(title: "Headers", fields: [:])
                }
                
                if let body = apiCall.requestBody, !body.isEmpty {
                    sectionBody(title: "Body", type: apiCall.requestShortType ?? .OTHER, value: body)
                } else {
                    sectionBody(title: "Body", type: .OTHER, value: "")
                }
            }
            .padding()
        }
    }
    
    private var responseView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let headers = apiCall.responseHeaders, !headers.isEmpty {
                    sectionHeader(title: "Headers", fields: headers)
                } else {
                    sectionHeader(title: "Headers", fields: [:])
                }
                
                if let body = apiCall.responseBody, !body.isEmpty {
                    sectionBody(title: "Body", type: apiCall.responseShortType ?? .OTHER, value: body)
                } else {
                    sectionBody(title: "Body", type: .OTHER, value: "")
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func sectionHeader(title: String, fields: [String: String]) -> some View {
        VStack(alignment: .leading) {
            Text(title).bold()
            
            ForEach(fields.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                FieldView(
                    title: key,
                    value: value
                )
                .fieldStyle()
            }
        }
    }
    
    @ViewBuilder
    func sectionBody(title: String, type: ApiCallType, value: String) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title).bold()
                Spacer()
                
                if type == .HTML {
                    Picker("", selection: $sectionBody) {
                        Text("Preview").tag(0)
                        Text("Raw").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
            }
            
            if (!value.isEmpty) {
                switch type {
                case .JSON:
                    Text(value.toPretty())
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                case .XML:
                    Text(value)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                case .HTML:
                    if sectionBody == 0 {
                        WebView(html: value)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(10/16, contentMode: .fit)
                            .cornerRadius(20)
                    } else {
                        Text(value.toPretty())
                            .font(.system(.caption, design: .monospaced))
                            .padding()
                    }
                case .IMAGE:
                    value.toImage()?
                        .resizable()
                        .scaledToFit()
                        .frame(width: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(20)
                case .OTHER:
                    Text(value)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        NetworkDetailView(apiCall: ApiCall(
            requestURL: "https://api.example.com/v1/users?page=1",
            requestMethod: "POST",
            requestDate: Date(),
            requestBody: "{\"name\":\"John\"}",
            requestType: "application/json",
            requestShortType: .JSON,
            responseStatus: 200,
            responseDate: Date(),
            responseHeaders: ["Content-Type": "application/json"],
            responseBody: "{\"ok\":true}",
            responseType: "application/json",
            responseShortType: .JSON,
            timeInterval: 1.24,
            noResponse: false
        ))
    }
}
