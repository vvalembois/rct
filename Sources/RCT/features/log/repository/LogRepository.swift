//
//  LogRepository.swift
//  RCT
//
//  Created by Vincent on 30/09/2025.
//

import SwiftUI

class LogRepository: ObservableObject {
    
    nonisolated(unsafe) static let shared = LogRepository()
    
    @Published var logs: [Log] = [] {
        didSet { saveLogs() }
    }
    
    private let logKey = "logs_key"
    
    init() {
        loadLogs()
    }
    
    private func saveLogs() {
        if let encoded = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(encoded, forKey: logKey)
        }
    }
    
    private func loadLogs() {
        guard let data = UserDefaults.standard.data(forKey: logKey) else { return }
        if let decoded = try? JSONDecoder().decode([Log].self, from: data) {
            logs = decoded
        }
    }
    
    func addLog(_ log: Log) {
        logs.append(log)
    }
    
    func clear() {
        logs.removeAll()
    }
}
