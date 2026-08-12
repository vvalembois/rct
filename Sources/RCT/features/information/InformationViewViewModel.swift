//
//  InformationViewViewModel.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation

#if os(iOS)
import UIKit
#endif

typealias Information = (key: String, value: Any)

struct MySection: Identifiable {
    let id = UUID()
    let name: String
    let informations: [Information]
}

class InformationViewViewModel: ObservableObject {
    
    @Published var sections: [MySection] = []
    
    @MainActor func load() {
        sections = [
            MySection(
                name: "Application",
                informations: [
                    Information(key: "Name", value: Bundle.main.infoDictionary?["CFBundleName"] ?? ""),
                    Information(key: "Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""),
                    Information(key: "Build", value: Bundle.main.infoDictionary?["CFBundleVersion"] ?? "")
                ]
            )
        ]
        
        #if canImport(UIKit)
        sections.append(
            MySection(
                name: "Phone",
                informations: [
                    Information(key: "Name", value: UIDevice.current.name),
                    Information(key: "Software Version", value: "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"),
                    Information(key: "Model", value: UIDevice.current.model),
                    Information(key: "Model Name", value: UIDevice.modelName)
                ]
            )
        )
        #endif
    }
}
