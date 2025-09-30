//
//  UrlRequest+Ext.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import Foundation

extension URLRequest {
    func getCachePolicy() -> String {
        switch cachePolicy {
        case .useProtocolCachePolicy: return "UseProtocolCachePolicy"
        case .reloadIgnoringLocalCacheData: return "ReloadIgnoringLocalCacheData"
        case .reloadIgnoringLocalAndRemoteCacheData: return "ReloadIgnoringLocalAndRemoteCacheData"
        case .returnCacheDataElseLoad: return "ReturnCacheDataElseLoad"
        case .returnCacheDataDontLoad: return "ReturnCacheDataDontLoad"
        case .reloadRevalidatingCacheData: return "ReloadRevalidatingCacheData"
        @unknown default: return "Unknown \(cachePolicy)"
        }
    }
    
    func getURLComponents() -> URLComponents? {
        return URLComponents(string: url?.absoluteString ?? "")
    }
    
    func getBody() -> Data {
        return httpBodyStream?.readfully() ?? URLProtocol.property(forKey: "BodyData", in: self) as? Data ?? Data()
    }
}
