//
//  LogLevel.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

/// Log level to use for execution.
public enum LogLevel: String, Equatable {
    case debug
    case info
    case warning
    case error
    case off

    public static var `default`: LogLevel { .info }

    private var intValue: Int {
        switch self {
        case .debug: return 0
        case .info: return 1
        case .warning: return 2
        case .error: return 3
        case .off: return 4
        }
    }

    static func <= (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.intValue <= rhs.intValue
    }
}
