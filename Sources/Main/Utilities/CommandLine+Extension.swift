//
//  CommandLine+Extension.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

public extension CommandLine {
    enum CommandLineOption: String, CaseIterable {
        case key
        case from
        case to
        case newKey = "new-key"
        case dryRun = "dry-run"
        case help

        var usage: String {
            switch self {
            case .key:
                return "--key=<key>"
            case .from:
                return "--from=<path>"
            case .to:
                return "--to=<path>"
            case .newKey:
                return "--new-key=<key>"
            case .dryRun:
                return "--dry-run"
            case .help:
                return "--help"
            }
        }

        var description: String {
            switch self {
            case .key:
                return "Key to search for in source localization files"
            case .from:
                return "Path to source localization files"
            case .to:
                return "Path to destination localization files (optional - defaults to source path)"
            case .newKey:
                return "Key to write to new files (optional - defaults to original key)"
            case .dryRun:
                return "Perform a dry run without actually modifying files (optional)"
            case .help:
                return "Show this help message"
            }
        }
    }

    static func argument(_ option: CommandLineOption) -> String? {
        arguments.compactMap { argument -> String? in
            guard let match = argument.firstMatch(of: Regex<Any>.argument) else {
                return nil
            }
            guard match.output.argumentName == option.rawValue else {
                return nil
            }

            // If no value, it's a boolean type argument.
            guard let stringValue = match.output.argumentValue else { return "true" }
            guard let unquotedStringValue = stringValue.firstMatch(of: Regex<Any>.quotedValue)?.output.value else {
                return "\(stringValue)"
            }

            return "\(unquotedStringValue)"
        }.first
    }

    static func printUsage() {
        print("🪄  Portkey - Instantly transport localization keys wherever they need to go.\n")
        print("Usage:\n\tportkey --key=<key> --from=<sourcePath> --to=<destinationPath>\n")
        print("Example:\n\tportkey --key=\"page.title\" --from=./ModuleA/Localization --to=./ModuleB/Localization\n")
        print("Options:")
        for item in CommandLineOption.allCases {
            print("\t\(item.usage)\n\t\t\(item.description)\n")
        }
    }
}
