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
            return self
        }
    }
    
    func maskingSensitiveKeys(_ sensitiveKeys: [String] = []) -> String {
        var result = self

        let separators: CharacterSet = [
            "&", "\n", "{", "}", ",", "\""
        ]

        for key in sensitiveKeys {
            let patterns = [
                "\(key)=",
                "\(key) =",
                "\(key):",
                "\(key) :"
            ]

            // On traite les occurrences de droite à gauche.
            for pattern in patterns {
                var matches: [Range<String.Index>] = []
                var searchStart = result.startIndex

                while searchStart < result.endIndex,
                      let range = result.range(
                        of: pattern,
                        options: [.caseInsensitive],
                        range: searchStart..<result.endIndex
                      ) {
                    matches.append(range)
                    searchStart = range.upperBound
                }

                for keyRange in matches.reversed() {
                    var valueStart = keyRange.upperBound

                    // Ignore les espaces après "=" ou ":"
                    while valueStart < result.endIndex,
                          result[valueStart] == " " {
                        valueStart = result.index(after: valueStart)
                    }

                    var valueEnd = result.endIndex

                    for index in result.indices[valueStart...] {
                        if let scalar = result[index].unicodeScalars.first,
                           separators.contains(scalar) {
                            valueEnd = index
                            break
                        }
                    }

                    if valueStart < valueEnd {
                        result.replaceSubrange(
                            valueStart..<valueEnd,
                            with: "****"
                        )
                    }
                }
            }
        }

        return result
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
