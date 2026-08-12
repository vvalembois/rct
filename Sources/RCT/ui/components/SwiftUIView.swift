//
//  SwiftUIView.swift
//  RCT
//
//  Created by Vincent on 13/10/2025.
//

import SwiftUI

struct SectionView<Content: View>: View {
    
    let title: String
    
    let content: Content
    
    init(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            
            content
                .padding()
                .background(.red)
                .cornerRadius(20)
        }
    }
}

#Preview {
    SectionView(title: "Title") {
        VStack(spacing: 20) {
            Text("Content 1")
            Text("Content 2")
        }
    }
    .padding()
}
