//
//  Date+Ext.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import Foundation

extension Date {
    func formattedTime() -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        guard let hour = components.hour, let minute = components.minute else {
            return ""
        }
        return String(format: "%d:%02d", hour, minute)
    }    
}
