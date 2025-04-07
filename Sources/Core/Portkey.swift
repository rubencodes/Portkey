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
    private let newKey: String?
    private let sourcePath: String
    private let destinationPath: String?
    private let isDryRun: Bool
    private let logger: Logger

    private let supportedFileTypes: [LocalizationFile.Type] = [
        StringsFile.self,
        // TODO: Add StringsDictFile.self here in the future
    ]

    // MARK: - Lifecycle

    public init(key: String, newKey: String?, sourcePath: String, destinationPath: String?, isDryRun: Bool) {
        self.key = key
        self.newKey = newKey
        self.sourcePath = sourcePath
        self.destinationPath = destinationPath
        self.isDryRun = isDryRun
        logger = .init(logLevel: isDryRun ? .debug : .default)
    }

    // MARK: - Public Functions

    public func run() throws {
        let fileManager: FileManager = .default
        let fileReader: FileReading = FileHandler()
        let fileWriter: FileWriting = isDryRun ? NoopFileHandler() : FileHandler()

        if isDryRun {
            logger.info("⚠️ Dry run mode enabled. No files will be moved.")
        }

        let sourceLocales = try fileManager.contentsOfDirectory(atPath: sourcePath).filter { $0.hasSuffix(".lproj") }
        var hasSuccessfullyMovedKey = false
        for locale in sourceLocales {
            for fileType in supportedFileTypes {
                // Check that the source file exists, and that the key exists within source file.
                guard let source = fileType.init(directoryPath: sourcePath,
                                                 locale: locale,
                                                 fileManager: fileManager,
                                                 fileReader: fileReader,
                                                 fileWriter: fileWriter),
                    source.containsKey(key)
                else {
                    continue
                }

                // Check that the destination file exists.
                guard let destination = fileType.init(directoryPath: destinationPath ?? sourcePath,
                                                      locale: locale,
                                                      fileManager: fileManager,
                                                      fileReader: fileReader,
                                                      fileWriter: fileWriter)
                else {
                    logger.error("❌ Found key \(key) at source path \(source.path), but no destination of type \(String(describing: fileType)) for locale \(locale). Skipping.")
                    continue
                }

                // Check that the new key doesn't exist in the destination file.
                let destinationKey = newKey ?? key
                if destination.containsKey(destinationKey) {
                    logger.warning("⚠️ Destination already contains key '\(destinationKey)' in \(locale). Skipping.")
                    continue
                }

                // Meat & Potatoes: Move key from source to newKey at destination.
                guard var entry = try source.removeEntry(forKey: key) else { continue }
                if key != destinationKey {
                    entry = entry.replacingOccurrences(of: "\"\(key)\"", with: "\"\(destinationKey)\"")
                }
                try destination.appendEntry(entry)

                // All set!
                hasSuccessfullyMovedKey = true
                if key != destinationKey {
                    logger.debug("✅ Moved '\(key)' to '\(destinationKey)' in \(locale)")
                } else {
                    logger.debug("✅ Moved '\(key)' in \(locale)")
                }
                break
            }
        }

        if !hasSuccessfullyMovedKey {
            logger.error("❌ Failed to find key \"\(key)\" in source directory \(sourcePath)")
            throw PortkeyError.failedToFindKey
        }

        if isDryRun {
            logger.info("⚠️ Dry run mode ended.")
        }
    }
}
