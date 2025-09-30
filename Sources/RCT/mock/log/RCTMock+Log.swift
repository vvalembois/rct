//
//  Log.swift
//  RCT
//
//  Created by Vincent on 05/10/2025.
//

extension RCTMock {
    
    static public func getMockLog(
        type: LogType = .info,
        message: String = "Hello World",
        time: Double = 1633074800,
        className: String = "TestClass"
    ) -> Log {
        return Log(
            type: type,
            message: message,
            time: time,
            className: className
        )
    }
}
