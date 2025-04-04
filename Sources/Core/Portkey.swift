//
//  Portkey.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/4/25.
//

import Foundation

public struct Portkey {

    // MARK: - Private Properties

    private let key: String
    private let newKey: String
    private let sourcePath: String
    private let destinationPath: String

    private let supportedFileTypes: [LocalizationFile.Type] = [
        StringsFile.self
        // TODO: Add StringsDictFile.self here in the future
    ]

    // MARK: - Lifecycle

    public init(key: String, newKey: String, sourcePath: String, destinationPath: String) {
        self.key = key
        self.newKey = newKey
        self.sourcePath = sourcePath
        self.destinationPath = destinationPath
    }

    // MARK: - Public Functions

    public func run(fileManager: FileManager = .default) throws {
        let sourceLocales = try fileManager.contentsOfDirectory(atPath: sourcePath).filter { $0.hasSuffix(".lproj") }
        var hasSuccessfullyMovedKey: Bool = false
        for locale in sourceLocales {
            for fileType in supportedFileTypes {
                // Check that the source file exists, and that the key exists within source file.
                guard let source = fileType.init(directoryPath: sourcePath, locale: locale, fileManager: fileManager), source.containsKey(key) else { continue }

                // Check that the destination file exists.
                guard let destination = fileType.init(directoryPath: destinationPath, locale: locale, fileManager: fileManager) else {
                    print("❌ Found key \(key) at source path \(source.path), but no destination of type \(String(describing: fileType)) for locale \(locale). Skipping.")
                    continue
                }

                // Check that the new key doesn't exist in the destination file.
                if destination.containsKey(newKey) {
                    print("⚠️ Destination already contains key '\(newKey)' in \(locale). Skipping.")
                    continue
                }

                // Meat & Potatoes: Move key from source to newKey at destination.
                guard var entry = try source.removeEntry(forKey: key) else { continue }
                if key != newKey {
                    entry = entry.replacingOccurrences(of: "\"\(key)\"", with: "\"\(newKey)\"")
                }
                try destination.appendEntry(entry)

                // All set!
                hasSuccessfullyMovedKey = true
                if key != newKey {
                    print("✅ Moved '\(key)' to '\(newKey)' in \(locale)")
                } else {
                    print("✅ Moved '\(key)' in \(locale)")
                }
                break
            }
        }

        if !hasSuccessfullyMovedKey {
            print("❌ Failed to find key \"\(key)\" in source directory \(sourcePath)")
        }
    }
}
