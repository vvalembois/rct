//
//  NetworkScope.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

import Foundation
import RCTUI

/// Status filter of the network screen.
enum NetworkScope: String, DSScope {
    case anyStatus
    case success
    case redirect
    case clientError
    case serverError
    case failed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .anyStatus: return "All"
        case .success: return "2xx"
        case .redirect: return "3xx"
        case .clientError: return "4xx"
        case .serverError: return "5xx"
        case .failed: return "Failed"
        }
    }

    func matches(_ call: ApiCall) -> Bool {
        guard let status = call.responseStatus else { return self == .anyStatus || self == .failed }
        switch self {
        case .anyStatus: return true
        case .success: return (200..<300).contains(status)
        case .redirect: return (300..<400).contains(status)
        case .clientError: return (400..<500).contains(status)
        case .serverError: return status >= 500
        case .failed: return false
        }
    }
}

enum NetworkFilter {

    /// Filters calls by status scope and search text (URL, method or status code).
    static func apply(_ calls: [ApiCall], scope: NetworkScope, query: String) -> [ApiCall] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return calls
            .filter { scope.matches($0) }
            .filter { call in
                trimmed.isEmpty
                    || (call.requestURL ?? "").localizedCaseInsensitiveContains(trimmed)
                    || call.method.localizedCaseInsensitiveContains(trimmed)
                    || call.statusCodeText.localizedCaseInsensitiveContains(trimmed)
            }
    }

    /// `12 requests · 3 failed`.
    static func summary(_ calls: [ApiCall]) -> String {
        let failed = calls.filter { $0.statusTone == .critical }.count
        let requests = calls.count == 1 ? "1 request" : "\(calls.count) requests"
        return failed == 0 ? requests : "\(requests) · \(failed) failed"
    }
}
