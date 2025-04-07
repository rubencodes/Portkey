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
        let keys = CommandLine.stringArray(for: .key) + CommandLine.stringArray(for: .keys)
        let sourcePath = CommandLine.string(for: .from)
        let destinationPath = CommandLine.string(for: .to)
        let newKey = CommandLine.string(for: .newKey)
        let isDryRun = CommandLine.bool(for: .dryRun)

        // Ensure some key exists, and source path exists.
        guard keys.isEmpty == false else {
            throw InitializationError.missingKey
        }

        guard keys.isEmpty == false, let sourcePath, sourcePath.isEmpty == false else {
            throw InitializationError.missingSourcePath
        }

        // Ensure we're changing the path and/or changing the key name.
        guard sourcePath != destinationPath || newKey != nil else {
            throw InitializationError.missingRequiredArguments
        }

        return self.init(keys: keys,
                         newKey: newKey,
                         sourcePath: sourcePath,
                         destinationPath: destinationPath,
                         isDryRun: isDryRun)
    }
}
