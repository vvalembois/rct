//
//  LogRepository.swift
//  RCT
//
//  Created by Vincent on 30/09/2025.
//

import SwiftUI

final class LogRepository: ObservableObject, @unchecked Sendable {
    
    nonisolated(unsafe) static let shared = LogRepository()
    
    @Published var logs: [LogEntry] = [] {
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
        if let decoded = try? JSONDecoder().decode([LogEntry].self, from: data) {
            logs = decoded
        }
    }
    
    /// `rct_log` can be called from any thread: published changes are always applied on the main thread.
    func addLog(_ log: LogEntry) {
        performOnMain { self.logs.append(log) }
    }
    
    func clear() {
        performOnMain { self.logs.removeAll() }
    }
    
    private func performOnMain(_ block: @escaping @Sendable () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
