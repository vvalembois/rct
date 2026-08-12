//
//  InformationView.swift
//
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation
import SwiftUI

struct InformationView: View {
    
    @ObservedObject var viewModel: InformationViewViewModel
    
    init(informationViewViewModel: InformationViewViewModel = InformationViewViewModel()) {
        self.viewModel = informationViewViewModel
    }
    
    var body: some View {
        List(viewModel.sections) { data in
            section(section: data)
        }
        .onAppear {
            viewModel.load()
        }
        .platformNavigationTitle(MenuItem.information.title)
        #if os(iOS)
        .platformToolbar(
            navigationBarLeading: {
                Button(
                    action: { RCT.sharedInstance().motionDetected() },
                    label: { Label("Close", systemImage: "xmark") }
                )
            },
            navigationBarTrailing: {
                Button(
                    action: {  },
                    label: { Label("Download", systemImage: "square.and.arrow.up") }
                )
            }
        )
        #elseif os(macOS)
        .platformToolbar(
            navigationBarTrailing: {
                Button(
                    action: {  },
                    label: { Label("Download", systemImage: "square.and.arrow.up") }
                )
            }
        )
        #endif
    }
    
    @ViewBuilder
    func section(section: MySection) -> some View {
        VStack(alignment: .leading) {
            Text(section.name).bold()
            
            ForEach(section.informations.indices, id: \.self) { indexInfo in
                FieldView(
                    title: section.informations[indexInfo].key,
                    value: (section.informations[indexInfo].value as? String) ?? ""
                )
                .fieldStyle()
            }
        }
    }
}

#Preview {
    InformationView()
}
