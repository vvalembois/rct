//
//  String+Ext.swift
//  RCT
//
//  Created by Vincent on 29/09/2025.
//

import Foundation

import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension String {
    
    func getTypeFrom() -> ApiCallType {
        let lowerType = self.lowercased()

        if lowerType == "application/json" || lowerType.hasSuffix("+json") {
            return .JSON
        }

        switch lowerType {
        case "application/xml", "text/xml":
            return .XML
        case "text/html":
            return .HTML
        default:
            return lowerType.hasPrefix("image/") ? .IMAGE : .OTHER
        }
    }
    
    func toPretty() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            return String(data: prettyData, encoding: .utf8) ?? self
        } catch {
            print("❌ Invalid JSON:", error)
            return self
        }
    }
    
    func toImage() -> Image? {
        guard let data = Data(base64Encoded: self) else { return nil }

        #if os(iOS)
            guard let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        #elseif os(macOS)
            guard let nsImage = NSImage(data: data) else { return nil }
            return Image(nsImage: nsImage)
        #else
            return nil
        #endif
    }
}
