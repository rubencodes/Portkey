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
    private let sourcePath: String
    private let destinationPath: String

    private let supportedFileTypes: [LocalizationFile.Type] = [
        StringsFile.self
        // TODO: Add StringsDictFile.self here in the future
    ]

    // MARK: - Lifecycle

    public init(key: String, sourcePath: String, destinationPath: String) {
        self.key = key
        self.sourcePath = sourcePath
        self.destinationPath = destinationPath
    }

    // MARK: - Public Functions

    public func run(fileManager: FileManager = .default) throws {
        let sourceLocales = try fileManager.contentsOfDirectory(atPath: sourcePath).filter { $0.hasSuffix(".lproj") }
        var hasSuccessfullyMovedKey: Bool = false
        for locale in sourceLocales {
            for fileType in supportedFileTypes {
                guard let source = fileType.init(directoryPath: sourcePath, locale: locale, fileManager: fileManager), source.containsKey(key) else { continue }
                guard let destination = fileType.init(directoryPath: destinationPath, locale: locale, fileManager: fileManager) else {
                    print("❌ Found key \(key) at source path \(source.path), but no destination of type \(String(describing: fileType)) for locale \(locale). Skipping.")
                    continue
                }

                guard let entry = try source.removeEntry(forKey: key) else { continue }
                try destination.appendEntry(entry)
                hasSuccessfullyMovedKey = true
                print("✅ Moved '\(key)' in \(locale)")
                break
            }
        }

        if !hasSuccessfullyMovedKey {
            print("❌ Failed to find key \"\(key)\" in source directory \(sourcePath)")
        }
    }
}
