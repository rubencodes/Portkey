//
//  main.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/4/25.
//

import Core
import Foundation

// In help mode, print usage and exit.
let isHelp = CommandLine.arguments.bool(for: .help)
guard isHelp == false else {
    CommandLine.printUsage()
    exit(0)
}

do {
    let porkey = try Portkey.create()
    try porkey.run()
} catch is PortkeyError {
    exit(1)
} catch {
    print("❌ Error: \(error.localizedDescription)")
    CommandLine.printUsage()
    exit(1)
}
