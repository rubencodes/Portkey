//
//  main.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/4/25.
//

import Core
import Foundation

guard CommandLine.arguments.count > 1 else {
    CommandLine.printUsage()
    exit(1)
}

let key = CommandLine.argument(.key)
let sourcePath = CommandLine.argument(.from)
let destinationPath = CommandLine.argument(.to)
let newKey = CommandLine.argument(.newKey)
let isDryRun: Bool = .init(CommandLine.argument(.dryRun) ?? "false") ?? false
let isHelp: Bool = .init(CommandLine.argument(.help) ?? "false") ?? false

// In help mode, print usage and exit.
guard isHelp == false else {
    CommandLine.printUsage()
    exit(0)
}

// Ensure key exists, and source path exists.
guard let key, key.isEmpty == false, let sourcePath, sourcePath.isEmpty == false else {
    CommandLine.printUsage()
    exit(1)
}

// Ensure we're changing the path and/or changing the key name.
guard sourcePath != destinationPath || newKey != nil else {
    CommandLine.printUsage()
    exit(1)
}

do {
    let porkey = Portkey(key: key,
                         newKey: newKey ?? key,
                         sourcePath: sourcePath,
                         destinationPath: destinationPath ?? sourcePath,
                         isDryRun: isDryRun)
    try porkey.run()
} catch is PortkeyError {
    exit(1)
} catch {
    print("❌ Error: \(error.localizedDescription)")
    exit(1)
}
