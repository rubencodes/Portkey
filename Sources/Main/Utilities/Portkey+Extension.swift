//
//  Portkey+Extension.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/7/25.
//

import Core
import Foundation

extension Portkey {
    enum InitializationError: Error, LocalizedError {
        case missingKey
        case missingSourcePath
        case missingRequiredArguments

        var errorDescription: String? {
            switch self {
            case .missingKey:
                return "Valid --key or --keys argument not found."
            case .missingSourcePath:
                return "Valid --from argument not found."
            case .missingRequiredArguments:
                return "Missing required arguments for destination path or new key name."
            }
        }
    }

    static func create(from arguments: [String] = CommandLine.arguments) throws -> Portkey {
        let keys = arguments.stringArray(for: .key) + arguments.stringArray(for: .keys)
        let sourcePath = arguments.string(for: .from)
        let destinationPath = arguments.string(for: .to)
        let newKey = arguments.string(for: .newKey)
        let isDryRun = arguments.bool(for: .dryRun)

        // Ensure some key exists, and source path exists.
        guard keys.isEmpty == false else {
            throw InitializationError.missingKey
        }

        guard keys.isEmpty == false, let sourcePath, sourcePath.isEmpty == false else {
            throw InitializationError.missingSourcePath
        }

        // Ensure we're changing the path and/or changing the key name.
        guard (destinationPath != nil && destinationPath != sourcePath) || (newKey != nil && !keys.contains(newKey ?? "")) else {
            throw InitializationError.missingRequiredArguments
        }

        return self.init(keys: keys,
                         newKey: newKey,
                         sourcePath: sourcePath,
                         destinationPath: destinationPath,
                         isDryRun: isDryRun)
    }
}
