//
//  DefaultStringInterpolation+Extension.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

import Foundation

extension DefaultStringInterpolation {
    /// Used to print with a given color, e.g. print("\("foo", color: .magenta)")
    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T, color: ASCIIColor) {
        appendInterpolation("\(color.rawValue)\(value)\(ASCIIColor.default.rawValue)")
    }
}
