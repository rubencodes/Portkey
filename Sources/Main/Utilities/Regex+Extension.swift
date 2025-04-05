//
//  Regex+Extension.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

extension Regex {
    /// Matches command line arguments, e.g. `--foo="bar"` or `--foo-bar=baz` or `--foo`
    /// Captures the argument name and the optional argument value.
    static var argument: Regex<(Substring, argumentName: Substring, argumentValue: Substring?)> {
        #/^-{1,2}(?<argumentName>[\w-]+)(?:=(?<argumentValue>(?:"[^"]*"|'[^']*'|[^\s]+)))?/#
    }

    /// Matches quoted values
    static var quotedValue: Regex<(Substring, Substring, value: Substring)> {
        #/^(["'])(?<value>.*)\1$/#
    }
}
