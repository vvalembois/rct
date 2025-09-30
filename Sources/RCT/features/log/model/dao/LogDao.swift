//
//  LogDao.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

import Foundation

struct LogDao: Encodable, Decodable {
    var type: String
    var message: String
    var time: TimeInterval
    var className: String
}
