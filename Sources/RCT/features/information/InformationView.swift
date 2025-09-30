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
        .listStyle(.insetGrouped)
        .navigationBarTitle("Informations", displayMode: .large)
        .onAppear {
            viewModel.load()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: { RCT.sharedInstance().motionDetected() },
                    label: { Label("Close", systemImage: "xmark") }
                )
            }
        }
    }
    
    @ViewBuilder
    func section(section: MySection) -> some View {
        Section(header: Text(section.name)) {
            ForEach(section.informations.indices, id: \.self) { indexInfo in
                HStack(alignment: .top) {
                    Text(section.informations[indexInfo].key)
                    Spacer()
                    Text((section.informations[indexInfo].value as? String) ?? "")
                }
            }
        }
    }
}

#Preview {
    InformationView()
}
