//
//  Log.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation
import OSLog
import SwiftUI

struct Log: Identifiable, Codable {
    let id = UUID()
    var type: LogType
    var message: String
    var time: TimeInterval
    var className: String
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss a"
        return formatter
    }()

    enum CodingKeys: String, CodingKey {
        case type
        case message
        case time
        case className
    }
    
    func toString() -> String {
        let date = Date(timeIntervalSince1970: time)
        return "[\(type.rawValue)] [\(dateFormatter.string(from: date))]: \(message)"
    }
}

extension Log {
    
    func getImage() -> String {
        var systemImage = ""
        switch type {
        case .info:
            systemImage = "info.circle.fill"
        case .error:
            systemImage = "exclamationmark.circle.fill"
        default:
            systemImage = "ladybug.circle.fill"
        }
        return systemImage
    }
    
    func getColor() -> Color {
        switch type {
        case .info:
            return .green.opacity(0.5)
        case .error:
            return .red.opacity(0.5)
        default:
            return .orange.opacity(0.5)
        }
    }
}

extension Log: Persistable {

    init(managedObject: LogDao) {
        self.type = LogType(rawValue: managedObject.type) ?? .error
        self.message = managedObject.message
        self.time = managedObject.time
        self.className = managedObject.className
    }

    func managedObject() -> LogDao {
        return LogDao(
            type: type.rawValue,
            message: message,
            time: time,
            className: className
        )
    }
}
