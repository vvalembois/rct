//
//  NetworkProtocol.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//
import Foundation

class NetworkProtocol: URLProtocol, @unchecked Sendable {
    
    private static let internalKey = "com.helpReview.internal"
    
    private lazy var session: URLSession = { [weak self] in
        return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    private var model: ApiCall?
    
    private var response: URLResponse?
    
    private var responseData: NSMutableData?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return canServeRequest(request)
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        guard let request = task.currentRequest else { return false }
        return canServeRequest(request)
    }
    
    private class func canServeRequest(_ request: URLRequest) -> Bool {
        guard RCT.sharedInstance().started else {
            return false
        }
        
        guard URLProtocol.property(forKey: Self.internalKey, in: request) == nil, let url = request.url,
            (url.absoluteString.hasPrefix("http") || url.absoluteString.hasPrefix("https")) else {
            return false
        }

        return true
    }
    
    override func startLoading() {
        model = ApiCall(request)
        
        guard let mutableRequest = ((request as NSURLRequest).mutableCopy() as? NSMutableURLRequest) else {
            return
        }

        URLProtocol.setProperty(true, forKey: Self.internalKey, in: mutableRequest)
        session.dataTask(with: mutableRequest as URLRequest).resume()
    }
    
    override func stopLoading() {
        session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach { $0.cancel() }
        }
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}

extension NetworkProtocol: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        responseData?.append(data)
        client?.urlProtocol(self, didLoad: data)
    }
    
    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        self.response = response
        self.responseData = NSMutableData()
        
        client?.urlProtocol(
            self,
            didReceive: response,
            cacheStoragePolicy: URLCache.StoragePolicy.notAllowed
        )
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        defer {
            if let error = error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocolDidFinishLoading(self)
            }
        }
        
        if task.originalRequest == nil {
            return
        }

        if error != nil {
            model?.setToErrorResponse()
        } else if let response = response {
            let data = (responseData ?? NSMutableData()) as Data
            model?.saveResponse(response, data: data)
        }
        
        guard let model else {
            return
        }
        
        NetworkRepository.shared.add(model)
    }
    
    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?
    ) -> Void) {
        let updatedRequest: URLRequest
        if URLProtocol.property(forKey: Self.internalKey, in: request) != nil {
            guard let mutableRequest = ((request as NSURLRequest).mutableCopy() as? NSMutableURLRequest) else {
                return
            }

            URLProtocol.setProperty(true, forKey: Self.internalKey, in: mutableRequest)
            updatedRequest = mutableRequest as URLRequest
        } else {
            updatedRequest = request
        }
        
        client?.urlProtocol(self, wasRedirectedTo: updatedRequest, redirectResponse: response)
        completionHandler(updatedRequest)
    }
    
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @Sendable @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        let wrappedChallenge = URLAuthenticationChallenge(
            authenticationChallenge: challenge,
            sender: NetworkChallengeSender(handler: completionHandler)
        )
        client?.urlProtocol(self, didReceive: wrappedChallenge)
    }
}
