//
//  NetworkChallengeSender.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//
import Foundation

final class NetworkChallengeSender: NSObject, URLAuthenticationChallengeSender {
    
    typealias ChallengeHandler = @Sendable (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    
    let handler: ChallengeHandler
    
    init(handler: @escaping ChallengeHandler) {
        self.handler = handler
        super.init()
    }
    
    func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        handler(.useCredential, credential)
    }
    
    func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        handler(.useCredential, nil)
    }

    func cancel(_ challenge: URLAuthenticationChallenge) {
        handler(.cancelAuthenticationChallenge, nil)
    }

    func performDefaultHandling(for challenge: URLAuthenticationChallenge) {
        handler(.performDefaultHandling, nil)
    }

    func rejectProtectionSpaceAndContinue(with challenge: URLAuthenticationChallenge) {
        handler(.rejectProtectionSpace, nil)
    }
}
