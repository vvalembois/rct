//
//  Log.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation
import RCTUI

struct LogEntry: Identifiable, Codable {
    let id = UUID()
    var type: LogEntryType
    var message: String
    var time: TimeInterval
    var className: String

    enum CodingKeys: String, CodingKey {
        case type
        case message
        case time
        case className
    }
    
    var date: Date {
        Date(timeIntervalSince1970: time)
    }
    
    func toString() -> String {
        return "[\(type.rawValue)] [\(DSFormat.time(date))]: \(message)"
    }
}

extension LogEntry: Persistable {

    init(managedObject: LogDao) {
        self.type = LogEntryType(rawValue: managedObject.type) ?? .error
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
