//
//  HTTPModelManager.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//
import Foundation

class NetworkRepository: ObservableObject {
    
    nonisolated(unsafe) static let shared = NetworkRepository()
    
    @Published var calls = [ApiCall]()
    
    func add(_ apiCallModel: ApiCall) {
        self.calls.insert(apiCallModel, at: 0)
    }
    
    func clear() {
        self.calls.removeAll()
    }
}
