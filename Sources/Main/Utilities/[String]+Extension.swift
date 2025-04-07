//
//  [String]+Extension.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/7/25.
//

import Foundation

extension [String] {
    // MARK: - Internal Functions

    func string(for option: CommandLine.Option) -> String? {
        guard let stringValue = rawValue(for: option) else { return nil }
        guard let unquotedStringValue = stringValue.firstMatch(of: Regex<Any>.quotedValue)?.output.value else {
            return "\(stringValue)"
        }

        return "\(unquotedStringValue)"
    }

    func stringArray(for option: CommandLine.Option) -> [String] {
        guard let stringValue = rawValue(for: option) else { return [] }
        return stringValue
            .split(separator: ",")
            .compactMap { stringValue in
                guard let unquotedStringValue = stringValue.firstMatch(of: Regex<Any>.quotedValue)?.output.value else {
                    return "\(stringValue)"
                }

                return "\(unquotedStringValue)"
            }
            .filter { !$0.isEmpty }
    }

    func bool(for option: CommandLine.Option) -> Bool {
        rawValue(for: option) != nil
    }

    // MARK: - Private Functions

    func rawValue(for option: CommandLine.Option) -> String? {
        compactMap { argument -> String? in
            guard let match = argument.firstMatch(of: Regex<Any>.argument) else {
                return nil
            }
            guard match.output.argumentName == option.rawValue else {
                return nil
            }

            guard let value = match.output.argumentValue else {
                return ""
            }

            return "\(value)"
        }.first
    }
}
