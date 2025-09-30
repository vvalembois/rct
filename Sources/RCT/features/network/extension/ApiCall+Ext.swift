//
//  ApiCall+Ext.swift
//  RCT
//
//  Created by Vincent on 04/10/2025.
//

import SwiftUI

extension ApiCall {
    
    func getColor() -> Color {
        switch responseStatus {
        case .some(200...299):
            return .green.opacity(0.5)
        case .some(400...499):
            return .red.opacity(0.5)
        case .none:
            return .gray.opacity(0.5)
        default:
            return .gray.opacity(0.5)
        }
    }
}

extension ApiCall {
    
    func toCurl() -> String {
        var finalURL = requestURL ?? ""
        if var components = requestURLComponents {
            if let queryItems = requestURLQueryItems {
                components.queryItems = queryItems
            }
            if let urlString = components.url?.absoluteString {
                finalURL = urlString
            }
        }
    
        let method = requestMethod ?? "GET"
        var parts = ["curl -X \(method)"]
        
        if let headers = requestHeaders {
            for (key, value) in headers {
                let safeValue = value.replacingOccurrences(of: "\"", with: "\\\"")
                parts.append("-H \"\(key): \(safeValue)\"")
            }
        }
        
        if let body = requestBody, !body.isEmpty {
            let escapedBody = body.replacingOccurrences(of: "\"", with: "\\\"")
            parts.append("-d \"\(escapedBody)\"")
        }
        
        parts.append("\"\(finalURL)\"")
        
        return parts.joined(separator: " ")
    }
    
    // swiftlint:disable cyclomatic_complexity
    func toFullLogString() -> String {
        var log = [String]()

        log.append("=== REQUEST ===")
        if let method = requestMethod {
            log.append("Method: \(method)")
        }
        if let url = requestURL {
            log.append("URL: \(url)")
        }
        if let components = requestURLComponents {
            log.append("URLComponents: \(components)")
        }
        if let queryItems = requestURLQueryItems, !queryItems.isEmpty {
            let queries = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
            log.append("QueryItems: \(queries)")
        }
        if let headers = requestHeaders, !headers.isEmpty {
            let headerString = headers.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
            log.append("Headers:\n\(headerString)")
        }
        if let body = requestBody, !body.isEmpty {
            log.append("Body:\n\(body)")
        }
        if let date = requestDate {
            log.append("Request Date: \(date)")
        }

        log.append("\n=== RESPONSE ===")
        if let status = responseStatus {
            log.append("Status: \(status)")
        }
        if let date = responseDate {
            log.append("Response Date: \(date)")
        }
        if let type = responseType {
            log.append("Response Type: \(type)")
        }
        if let headers = responseHeaders, !headers.isEmpty {
            let headerString = headers.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
            log.append("Headers:\n\(headerString)")
        }
        if let body = responseBody, !body.isEmpty {
            log.append("Body:\n\(body)")
        }

        return log.joined(separator: "\n")
    }
    
    func toLogFile() -> URL? {
        let fileName = "request_\(uuid.uuidString)_log_.txt"
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)

        do {
            try toFullLogString().write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            rct_log(.error, message: "Erreur création fichier: \(error)")
            return nil
        }
    }
}
