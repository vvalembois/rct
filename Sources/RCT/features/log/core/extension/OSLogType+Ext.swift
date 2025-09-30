//
//  OSLogType+Ext.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation
import OSLog

extension OSLogType {
    func getName() -> String {
        switch self {
        case .info:
            return "Info"
        case .error:
            return "Error"
        default:
            return "Debug"
        }
    }
    
    func toLogType() -> LogType {
        switch self {
        case .info:
            return .info
        case .error:
            return .error
        default:
            return .warning
        }
    }
}
