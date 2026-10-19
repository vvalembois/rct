//
//  HTTPModelManager.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//
import Foundation

final class NetworkRepository: ObservableObject, @unchecked Sendable {
    
    nonisolated(unsafe) static let shared = NetworkRepository()
    
    @Published var calls = [ApiCall]()
    
    /// Calls are captured on URLSession delegate queues: published changes are always applied on the main thread.
    func add(_ apiCallModel: ApiCall) {
        performOnMain { self.calls.insert(apiCallModel, at: 0) }
    }
    
    func clear() {
        performOnMain { self.calls.removeAll() }
    }
    
    private func performOnMain(_ block: @escaping @Sendable () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
