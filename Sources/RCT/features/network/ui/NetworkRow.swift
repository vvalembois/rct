//
//  NetworkRow.swift
//  RCT
//
//  Created by Vincent on 02/10/2025.
//

import SwiftUI
import RCTUI

/// List row of a captured call: path, method · host · time, status code and duration.
struct NetworkRow: View {

    let call: ApiCall

    var body: some View {
        DSListRow(
            title: call.path,
            subtitle: "\(call.method) · \(call.host) · \(DSFormat.time(call.requestDate, milliseconds: false))",
            trailing: {
                VStack(alignment: .trailing, spacing: DSSpacing.xxSmall) {
                    DSStatusText(call.statusCodeText, tone: call.statusTone)
                    Text(call.durationText)
                        .font(.footnote.monospacedDigit())
                        .foregroundStyle(call.isSlow ? Color.orange : Color.secondary)
                }
            }
        )
        .dsCopyable(call.requestURL ?? "", title: "Copy URL")
    }
}

#Preview {
    List {
        NetworkRow(call: ApiCall(
            requestURL: "https://api.example.com/v1/users",
            requestMethod: "POST",
            requestDate: Date(),
            responseStatus: 201,
            timeInterval: 1.24,
            noResponse: false
        ))
        NetworkRow(call: ApiCall(requestURL: "https://api.exemple.com/data", requestMethod: "GET", requestDate: Date()))
    }
}
