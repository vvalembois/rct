//
//  NetworkItem.swift
//  RCT
//
//  Created by Vincent on 02/10/2025.
//
import SwiftUI

struct NetworkItem: View {
    
    let apiCall: ApiCall
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(spacing: 10) {
                Text(apiCall.requestDate?.formattedTime() ?? "").font(.headline)
                
                Text(String(format: "%.2f", apiCall.timeInterval ?? 0)).font(.subheadline)
            }
            .padding()
            .foregroundStyle(.white)
            .frame(maxHeight: .infinity)
            .background(apiCall.getColor())
            
            VStack(alignment: .leading, spacing: 20) {
                Text(apiCall.requestURL ?? "")
                    .font(.callout)
                    .lineLimit(2)
                
                Text("\(apiCall.requestMethod ?? "") \(apiCall.requestType ?? "")")
                    .font(.caption)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
    }
}

#Preview {
    NetworkItem(apiCall: RCTMock.getMockApiCall())
}
