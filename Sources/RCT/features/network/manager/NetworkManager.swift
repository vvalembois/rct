//
//  NetworkManager.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import Foundation

public class NetworkManager: @unchecked Sendable {
    
    static let shared: NetworkManager = .init()
    
    func start() {
        register()
        clearOldData()
    }
    
    func stop() {
        unregister()
        clearOldData()
    }
    
    func clear() {
        clearOldData()
    }
    
    func getLogsInString() -> String {
        return ""
    }
    
    private func register() {
        let implementHelpReview = NSSelectorFromString("implementHelpReview")
        if URLSessionConfiguration.responds(to: implementHelpReview) {
            URLSessionConfiguration.perform(implementHelpReview)
        }
        URLProtocol.registerClass(NetworkProtocol.self)

    }
    
    private func unregister() {
        URLProtocol.unregisterClass(NetworkProtocol.self)
    }
    
    private func clearOldData() {
        NetworkRepository.shared.clear()
    }
}
