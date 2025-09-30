//
//  Network.swift
//  RCT
//
//  Created by Vincent on 04/10/2025.
//

import Foundation

extension RCTMock {
    
    static public func getMockApiCall(
        url: String = "https://api.example.com/v1/users",
        post: String = "POST",
        type: String = "application/json",
        body: String = "{ \"id\": 1, \"name\": \"John Doe\" }",
        shortType: ApiCallType = .JSON
    ) -> ApiCall {
        return ApiCall(
            requestURL: url,
            requestURLComponents: URLComponents(string: url),
            requestURLQueryItems: [
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "limit", value: "50")
            ],
            requestMethod: post,
            requestCachePolicy: "reloadIgnoringLocalCacheData",
            requestDate: Date(),
            requestTime: "10:30:15",
            requestTimeout: "30s",
            requestHeaders: [
                "Content-Type": type,
                "Authorization": "Bearer exampleToken123"
            ],
            requestBodyLength: 128,
            requestBody: body,
            requestType: type,
            requestShortType: shortType,
            
            responseStatus: 200,
            responseDate: Date(),
            responseTime: "10:30:16",
            responseHeaders: [
                "Content-Type": type,
                "Cache-Control": "no-cache"
            ],
            responseBodyLength: 256,
            responseBody: body,
            responseType: type,
            responseShortType: shortType,
            
            timeInterval: 1.245,
            randomHash: UUID().uuidString,
            noResponse: false
        )
    }
}
