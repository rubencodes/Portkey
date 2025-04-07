//
//  Portkey.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/4/25.
//

import Foundation

public final class Portkey {
    // MARK: - Public Properties

    public let keys: [String]
    public let newKey: String?
    public let sourcePath: String
    public let destinationPath: String?
    public let isDryRun: Bool

    // MARK: - Private Properties

    private let logger: Logger
    private let supportedFileTypes: [LocalizationFile.Type] = [
        StringsFile.self,
        // TODO: Add StringsDictFile.self here in the future
    ]

    // MARK: - Lifecycle

    public init(keys: [String],
                newKey: String? = nil,
                sourcePath: String,
                destinationPath: String? = nil,
                isDryRun: Bool = false,
                logLevel: LogLevel = .default)
    {
        self.keys = keys
        self.newKey = keys.count == 1 ? newKey : nil
        self.sourcePath = sourcePath
        self.destinationPath = destinationPath
        self.isDryRun = isDryRun
        logger = .init(logLevel: isDryRun ? .debug : logLevel)
    }

    // MARK: - Public Functions

    public func run(fileManager: FileManaging = FileHandler(),
                    fileReader: FileReading = FileHandler(),
                    fileWriter: FileWriting = FileHandler()) throws
    {
        let fileWriter = isDryRun ? NoopFileWriter() : fileWriter
        if isDryRun {
            logger.info("⚠️ Dry run mode enabled. No files will be moved.")
        }

        let sourceLocales = try fileManager.contents(of: sourcePath).filter { $0.hasSuffix(".lproj") }
        guard sourceLocales.isEmpty == false else {
            logger.error("❌ No .lproj directories found at \(sourcePath).")
            throw PortkeyError.failedToFindSourceFiles
        }

        for key in keys {
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
                        logger.warning("⚠️ No source file of type \(String(describing: fileType)) for locale \(locale) was found with key \"\(key)\". Skipping.")
                        continue
                    }

                    // Check that the destination file exists.
                    guard let destination = fileType.init(directoryPath: destinationPath ?? sourcePath,
                                                          locale: locale,
                                                          fileManager: fileManager,
                                                          fileReader: fileReader,
                                                          fileWriter: fileWriter)
                    else {
                        logger.error("❌ Found source file of type \(String(describing: fileType)) for locale \(locale), but no matching destination file.")
                        throw PortkeyError.failedToFindMatchingDestinationFile
                    }

                    // Check that the new key doesn't exist in the destination file.
                    let destinationKey = newKey ?? key
                    guard destination.containsKey(destinationKey) == false else {
                        logger.warning("⚠️ Destination already contains key '\(destinationKey)' in \(locale).")
                        throw PortkeyError.keyCollisionAtDestination
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
            }
        }

        if isDryRun {
            logger.info("⚠️ Dry run mode ended.")
        }
    }
}
