//
//  rct.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import os
import OSLog

public func rct_log(_ type: LogType = .info, context: Any? = nil, message: String) {
    let log = Log(
        type: type,
        message: message,
        time: NSDate().timeIntervalSince1970,
        className: context == nil ? "" : getClassName(of: context!)
    )
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: context == nil ? "" : getClassName(of: context!))
    switch type {
    case .info:
        logger.info("\(message)")
    case .error:
        logger.error("\(message)")
    case .warning:
        logger.warning("\(message)")
    }
    
    if !RCT.shared.started { return }
    LogRepository.shared.addLog(log)
}

@available(*, deprecated, message: "Use rct_log(type: LogType, context: Any?, message: String) instead.")
public func rct_log(type: OSLogType = .info, context: Any? = nil, message: String) {
    let log = Log(
        type: type.toLogType(),
        message: message,
        time: NSDate().timeIntervalSince1970,
        className: context == nil ? "" : getClassName(of: context!)
    )
    os_log(type, "[%s] %s", log.className,  message)
    
    if !RCT.shared.started { return }
    LogRepository.shared.addLog(log)
}

func getClassName(of object: Any) -> String {
    return String(describing: type(of: object))
}
