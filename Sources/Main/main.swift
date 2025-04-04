//
//  main.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/4/25.
//

import Core
import Foundation

if CommandLine.arguments.count < 4 {
    print("🪄  Portkey - Instantly transport localization keys wherever they need to go.")
    print("Usage:\n\tportkey <key> <sourcePath> <destinationPath> [newKey]\n")
    print("Example:\n\tportkey \"page.title\" ./ModuleA ./ModuleB")
    print("or:\n\tportkey \"page.title\" ./ModuleA ./ModuleA \"page.title.new\"")
    exit(1)
}

let key = CommandLine.arguments[1]
let sourcePath = CommandLine.arguments[2]
let destinationPath = CommandLine.arguments[3]
let newKey = CommandLine.arguments.count >= 5 ? CommandLine.arguments[4] : CommandLine.arguments[1]

do {
    let localizer = Portkey(key: key, newKey: newKey, sourcePath: sourcePath, destinationPath: destinationPath)
    try localizer.run()
} catch {
    print("❌ Error: \(error)")
    exit(1)
}
