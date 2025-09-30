//
//  ApiCall.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import Foundation

class ApiCall: Identifiable {
    
    var uuid: UUID = UUID()
    
    var requestURL: String?
    var requestURLComponents: URLComponents?
    var requestURLQueryItems: [URLQueryItem]?
    var requestMethod: String?
    var requestCachePolicy: String?
    var requestDate: Date?
    var requestTime: String?
    var requestTimeout: String?
    var requestHeaders: [String: String]?
    var requestBodyLength: Int?
    var requestBody: String?
    var requestType: String?
    var requestShortType: ApiCallType?

    var responseStatus: Int?
    var responseDate: Date?
    var responseTime: String?
    var responseHeaders: [String: String]?
    var responseBodyLength: Int?
    var responseBody: String?
    var responseType: String?
    var responseShortType: ApiCallType?
    
    var timeInterval: Float?
    
    var randomHash: String?
    
    var noResponse: Bool = true
    
    init(_ request: URLRequest) {
        self.requestDate = Date()
        self.requestTime = self.requestDate?.formattedTime()
        self.requestURL = request.url?.absoluteString
        self.requestURLComponents = request.getURLComponents()
        self.requestURLQueryItems = request.getURLComponents()?.queryItems
        self.requestMethod = request.httpMethod
        self.requestCachePolicy = request.getCachePolicy()
        self.requestTimeout = String(Double(request.timeoutInterval))
        self.requestHeaders = request.allHTTPHeaderFields ?? Dictionary()
        
        if let contentType = requestHeaders?["Content-Type"] as? String {
            self.requestType = contentType
            self.requestShortType = contentType.getTypeFrom()
        }
        
        self.requestBodyLength = request.httpBody?.count ?? 0
        
        var bodyString: String?
        if self.requestShortType == .IMAGE {
            bodyString = request.httpBody?.base64EncodedString(options: .endLineWithLineFeed) as String?
        } else {
            bodyString = String(data: request.httpBody ?? Data(), encoding: .utf8)
        }
        self.requestBody = bodyString
    }
    
    init(
        requestURL: String? = nil,
        requestURLComponents: URLComponents? = nil,
        requestURLQueryItems: [URLQueryItem]? = nil,
        requestMethod: String? = nil,
        requestCachePolicy: String? = nil,
        requestDate: Date? = nil,
        requestTime: String? = nil,
        requestTimeout: String? = nil,
        requestHeaders: [String: String]? = nil,
        requestBodyLength: Int? = nil,
        requestBody: String? = nil,
        requestType: String? = nil,
        requestShortType: ApiCallType? = nil,
        
        responseStatus: Int? = nil,
        responseDate: Date? = nil,
        responseTime: String? = nil,
        responseHeaders: [String: String]? = nil,
        responseBodyLength: Int? = nil,
        responseBody: String? = nil,
        responseType: String? = nil,
        responseShortType: ApiCallType? = nil,
        
        timeInterval: Float? = nil,
        randomHash: String? = UUID().uuidString,
        noResponse: Bool = true
    ) {
        self.requestURL = requestURL
        self.requestURLComponents = requestURLComponents ?? (requestURL != nil ? URLComponents(string: requestURL!) : nil)
        self.requestURLQueryItems = requestURLQueryItems
        self.requestMethod = requestMethod
        self.requestCachePolicy = requestCachePolicy
        self.requestDate = requestDate
        self.requestTime = requestTime
        self.requestTimeout = requestTimeout
        self.requestHeaders = requestHeaders
        self.requestBodyLength = requestBodyLength
        self.requestBody = requestBody
        self.requestType = requestType
        self.requestShortType = requestShortType
        
        self.responseStatus = responseStatus
        self.responseDate = responseDate
        self.responseTime = responseTime
        self.responseHeaders = responseHeaders
        self.responseBodyLength = responseBodyLength
        self.responseBody = responseBody
        self.responseType = responseType
        self.responseShortType = responseShortType
        
        self.timeInterval = timeInterval
        self.randomHash = randomHash
        self.noResponse = noResponse
    }

    func setToErrorResponse() {
        self.responseDate = Date()
    }
    
    func saveResponse(_ response: URLResponse, data: Data) {
        self.noResponse = false
        
        self.responseDate = Date()
        self.responseTime = self.responseDate?.formattedTime()
        self.responseStatus = (response as? HTTPURLResponse)?.statusCode ?? 999
        self.responseHeaders = (response as? HTTPURLResponse)?.allHeaderFields.reduce(into: [:]) { result, item in
            if let key = item.key as? String,
               let value = item.value as? String {
                result[key] = value
            } else {
                result["\(item.key)"] = "\(item.value)"
            }
        }
        
        if let contentType = self.responseHeaders?["Content-Type"] as? String {
            self.responseType = contentType.components(separatedBy: ";")[0]
            self.responseShortType = contentType.components(separatedBy: ";")[0].getTypeFrom()
        }
        
        self.timeInterval = Float(self.responseDate!.timeIntervalSince(self.requestDate!))
        
        saveResponseBodyData(data)
    }
    
    private func saveResponseBodyData(_ data: Data) {
        var bodyString: String?
        
        if self.responseShortType == .IMAGE {
            bodyString = data.base64EncodedString(options: .endLineWithLineFeed) as String?
        } else {
            bodyString = String(data: data, encoding: .utf8)
        }
        
        if (bodyString != nil) {
            self.responseBodyLength = data.count
            self.responseBody = bodyString
        }
    }
}
