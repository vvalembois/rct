//
//  FieldStyle.swift
//  RCT
//
//  Created by Vincent on 03/10/2025.
//

import SwiftUI

struct FieldView: View {
    
    let title: String
    
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).bold()
            Text(value).font(.caption).lineLimit(6)
        }
    }
}

struct FieldStyle: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(color)
            .cornerRadius(20)
    }
}

extension View {
    func fieldStyle(color: Color = Color(.secondarySystemBackground)) -> some View {
        self.modifier(FieldStyle(color: color))
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        FieldView(title: "Titre", value: "Super Value")
        
        FieldView(title: "Titre", value: "Super Value").fieldStyle()
    }
    .padding()
    .frame(height: .infinity)
    .background(Color(.secondarySystemBackground))
}
