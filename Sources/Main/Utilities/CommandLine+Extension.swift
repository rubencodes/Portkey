//
//  CommandLine+Extension.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

public extension CommandLine {
    // MARK: - Nested Types

    enum Option: String, CaseIterable {
        case key
        case keys
        case from
        case to
        case newKey = "new-key"
        case dryRun = "dry-run"
        case help

        var usage: String {
            switch self {
            case .key:
                return "--key=<key>"
            case .keys:
                return "--keys=<comma separated keys>"
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

        var type: Any.Type {
            switch self {
            case .key, .keys: return [String].self
            case .from, .to, .newKey: return String.self
            case .dryRun, .help: return Bool.self
            }
        }

        var description: String {
            switch self {
            case .key:
                return "Key to search for in source localization files"
            case .keys:
                return "Comma separated keys to search for in source localization files (optional - ignored when `key` is provided)"
            case .from:
                return "Path to source localization files"
            case .to:
                return "Path to destination localization files (optional - defaults to source path)"
            case .newKey:
                return "Key to write to new files (optional - defaults to original key; ignored when `keys` is provided)"
            case .dryRun:
                return "Perform a dry run without actually modifying files (optional)"
            case .help:
                return "Show this help message"
            }
        }
    }

    // MARK: - Internal Functions

    static func printUsage() {
        print("🪄  Portkey - Instantly transport localization keys wherever they need to go.\n")
        print("Usage:\n\tportkey --key=<key> --from=<sourcePath> --to=<destinationPath>\n")
        print("Example:\n\tportkey --key=\"page.title\" --from=./ModuleA/Localization --to=./ModuleB/Localization\n")
        print("Options:")
        for item in CommandLine.Option.allCases {
            print("\t\(item.usage)\n\t\t\(item.description)\n")
        }
    }
}
