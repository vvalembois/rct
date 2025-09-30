//
//  Untitled.swift
//  RCT
//
//  Created by Vincent on 02/10/2025.
//

import SwiftUI

struct NetworkDetailView: View {
    
    @State private var section = 0
    
    @State private var showOptions = false
    
    @State private var export: IdentifiableObject?
    
    let apiCall: ApiCall

    var body: some View {
        VStack {
            Picker("What is your favorite color?", selection: $section) {
                Text("Informations").tag(0)
                Text("Request").tag(1)
                Text("Response").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            TabView(selection: $section) {
                infoView.tag(0)
                requestView.tag(1)
                responseView.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: section)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
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
                        export = IdentifiableObject(value: apiCall.toCurl())
                    }
                    Button("Export log") {
                        export = IdentifiableObject(value: apiCall.toFullLogString())
                    }
                    Button("Export File log") {
                        guard let file = apiCall.toLogFile() else { return }
                        export = IdentifiableObject(value: file)
                    }
                    Button("Cancel", role: .cancel) {
                        // Action annuler
                    }
                }
            }
        }
        .sheet(item: $export) { _ in
            if let export { ActivityView(activityItems: [export.value]) }
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
        List {
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
    }
    
    private var responseView: some View {
        List {
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
    }
    
    @ViewBuilder
    func sectionHeader(title: String, fields: [String: String]) -> some View {
        Section(header: Text(title)) {
            ForEach(fields.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                FieldView(title: key, value: value)
            }
        }
    }
    
    @ViewBuilder
    func sectionBody(title: String, type: ApiCallType, value: String) -> some View {
        Section(header: Text(title)) {
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
                    WebView(html: value)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(10/16, contentMode: .fit)
                        .cornerRadius(20)
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
        NetworkDetailView(apiCall: RCTMock.getMockApiCall())
    }
}
