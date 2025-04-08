//
//  PortkeyTests.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/7/25.
//

@testable import Core
import Foundation
import Testing

struct PortkeyTests {
    // MARK: - Basic Functionality

    @Test func test_itMovesSingleKey() throws {
        let key = "foo"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withKey: key, value: "Foo")
        let destinationPath: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationContent = ""
        let files = [
            sourcePath: sourceContent,
            destinationPath: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedDestinationContent = try fileHandler.read(from: destinationPath)
        #expect(updatedDestinationContent.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    @Test func test_itRenamesSingleKey() throws {
        let key = "foo"
        let newKey = "bar"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key],
                              newKey: newKey,
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withKey: key, value: "Foo")
        let destinationPath: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationContent = ""
        let files = [
            sourcePath: sourceContent,
            destinationPath: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedDestinationContent = try fileHandler.read(from: destinationPath)
        #expect(updatedDestinationContent.trimmingCharacters(in: .whitespacesAndNewlines) == .createStringsFile(withKey: newKey, value: "Foo").trimmingCharacters(in: .whitespacesAndNewlines))
    }

    @Test func test_itRenamesSingleKeyInPlace() throws {
        let key = "foo"
        let newKey = "bar"
        let sourceDirectory = "/a"
        let portkey = Portkey(keys: [key],
                              newKey: newKey,
                              sourcePath: sourceDirectory,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withKey: key, value: "Foo")
        let files = [
            sourcePath: sourceContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedSourceContent = try fileHandler.read(from: sourcePath)
        #expect(updatedSourceContent.trimmingCharacters(in: .whitespacesAndNewlines) == .createStringsFile(withKey: newKey, value: "Foo").trimmingCharacters(in: .whitespacesAndNewlines))
    }

    @Test func test_itMovesMultipleKeys() throws {
        let key1 = "foo"
        let key2 = "bar"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key1, key2],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withEntries: [
            (key1, "Foo"),
            (key2, "Bar"),
        ])
        let destinationPath: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationContent = ""
        let files = [
            sourcePath: sourceContent,
            destinationPath: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedDestinationContent = try fileHandler.read(from: destinationPath)
        #expect(updatedDestinationContent.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    @Test func test_itPreservesOtherSourceContent() throws {
        let key = "foo"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withEntries: [
            (key, "Foo"),
            ("some.other.key", "some other value"),
        ])
        let destinationPath: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationContent = ""
        let files = [
            sourcePath: sourceContent,
            destinationPath: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedSourceContent = try fileHandler.read(from: sourcePath)
        #expect(updatedSourceContent.trimmingCharacters(in: .whitespacesAndNewlines) == .createStringsFile(withKey: "some.other.key", value: "some other value").trimmingCharacters(in: .whitespacesAndNewlines))
    }

    @Test func test_itPreservesOtherDestinationContent() throws {
        let key = "foo"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withKey: key, value: "Foo")
        let destinationPath: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationContent: String = .createStringsFile(withKey: "some.other.key", value: "some other value")
        let files = [
            sourcePath: sourceContent,
            destinationPath: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedDestinationContent = try fileHandler.read(from: destinationPath)
        #expect(updatedDestinationContent.trimmingCharacters(in: .whitespacesAndNewlines) == [destinationContent, sourceContent].joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines))
    }

    @Test func test_itMovesSingleKeyMultipleLocales() throws {
        let key = "foo"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath1: String = .createPathForLocale("en", in: sourceDirectory)
        let sourcePath2: String = .createPathForLocale("fr", in: sourceDirectory)
        let sourcePath3: String = .createPathForLocale("es", in: sourceDirectory)
        let sourceContent1: String = .createStringsFile(withKey: key, value: "Foo")
        let sourceContent2: String = .createStringsFile(withKey: key, value: "Fóo")
        let sourceContent3: String = .createStringsFile(withKey: key, value: "Foò")
        let destinationPath1: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationPath2: String = .createPathForLocale("fr", in: destinationDirectory)
        let destinationPath3: String = .createPathForLocale("es", in: destinationDirectory)
        let destinationContent = ""
        let files = [
            sourcePath1: sourceContent1,
            sourcePath2: sourceContent2,
            sourcePath3: sourceContent3,
            destinationPath1: destinationContent,
            destinationPath2: destinationContent,
            destinationPath3: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedDestinationContent1 = try fileHandler.read(from: destinationPath1)
        let updatedDestinationContent2 = try fileHandler.read(from: destinationPath2)
        let updatedDestinationContent3 = try fileHandler.read(from: destinationPath3)
        #expect(updatedDestinationContent1.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent1.trimmingCharacters(in: .whitespacesAndNewlines))
        #expect(updatedDestinationContent2.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent2.trimmingCharacters(in: .whitespacesAndNewlines))
        #expect(updatedDestinationContent3.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent3.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    @Test func test_itMovesMultipleKeysMultipleLocales() throws {
        let key1 = "foo"
        let key2 = "bar"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key1, key2],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath1: String = .createPathForLocale("en", in: sourceDirectory)
        let sourcePath2: String = .createPathForLocale("fr", in: sourceDirectory)
        let sourcePath3: String = .createPathForLocale("es", in: sourceDirectory)
        let sourceContent1: String = .createStringsFile(withEntries: [
            (key1, "Foo"), (key2, "Bar"),
        ])
        let sourceContent2: String = .createStringsFile(withEntries: [
            (key1, "Fóo"), (key2, "Bâr"),
        ])
        let sourceContent3: String = .createStringsFile(withEntries: [
            (key1, "Foò"), (key2, "Bàr"),
        ])
        let destinationPath1: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationPath2: String = .createPathForLocale("fr", in: destinationDirectory)
        let destinationPath3: String = .createPathForLocale("es", in: destinationDirectory)
        let destinationContent = ""
        let files = [
            sourcePath1: sourceContent1,
            sourcePath2: sourceContent2,
            sourcePath3: sourceContent3,
            destinationPath1: destinationContent,
            destinationPath2: destinationContent,
            destinationPath3: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedDestinationContent1 = try fileHandler.read(from: destinationPath1)
        let updatedDestinationContent2 = try fileHandler.read(from: destinationPath2)
        let updatedDestinationContent3 = try fileHandler.read(from: destinationPath3)
        #expect(updatedDestinationContent1.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent1.trimmingCharacters(in: .whitespacesAndNewlines))
        #expect(updatedDestinationContent2.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent2.trimmingCharacters(in: .whitespacesAndNewlines))
        #expect(updatedDestinationContent3.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent3.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    // MARK: - Edge Cases

    @Test func test_throwsIfNoFilesFound() throws {
        let key = "foo"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let fileHandler = TestFileHandler(files: [:])
        #expect(throws: PortkeyError.failedToFindSourceFiles) {
            try portkey.run(fileManager: fileHandler,
                            fileReader: fileHandler,
                            fileWriter: fileHandler)
        }
    }

    @Test func test_throwsIfNoMatchingDestinationFileFound() throws {
        let key = "foo"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withKey: key, value: "Foo")
        let files = [
            sourcePath: sourceContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        #expect(throws: PortkeyError.failedToFindMatchingDestinationFile) {
            try portkey.run(fileManager: fileHandler,
                            fileReader: fileHandler,
                            fileWriter: fileHandler)
        }
    }

    @Test func test_throwsIfKeyCollision() throws {
        let key = "foo"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withKey: key, value: "Foo")
        let destinationPath: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationContent: String = .createStringsFile(withKey: key, value: "Bar")
        let files = [
            sourcePath: sourceContent,
            destinationPath: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        #expect(throws: PortkeyError.keyCollisionAtDestination) {
            try portkey.run(fileManager: fileHandler,
                            fileReader: fileHandler,
                            fileWriter: fileHandler)
        }
    }

    @Test func test_exitsSilentlyIfNoAffectedKeys() throws {
        let key = "foo"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: ["bar"],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withKey: key, value: "Foo")
        let destinationPath: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationContent: String = .createStringsFile(withKey: key, value: "Bar")
        let files = [
            sourcePath: sourceContent,
            destinationPath: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedSourceContent = try fileHandler.read(from: sourcePath)
        let updatedDestinationContent = try fileHandler.read(from: destinationPath)
        #expect(updatedSourceContent.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent.trimmingCharacters(in: .whitespacesAndNewlines))
        #expect(updatedDestinationContent.trimmingCharacters(in: .whitespacesAndNewlines) == destinationContent.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    @Test func test_exitsSilentlyIfDryRun() throws {
        let key = "foo"
        let sourceDirectory = "/a"
        let destinationDirectory = "/b"
        let portkey = Portkey(keys: [key],
                              sourcePath: sourceDirectory,
                              destinationPath: destinationDirectory,
                              isDryRun: true,
                              logLevel: .debug)
        let sourcePath: String = .createPathForLocale("en", in: sourceDirectory)
        let sourceContent: String = .createStringsFile(withKey: key, value: "Foo")
        let destinationPath: String = .createPathForLocale("en", in: destinationDirectory)
        let destinationContent = ""
        let files = [
            sourcePath: sourceContent,
            destinationPath: destinationContent,
        ]
        let fileHandler = TestFileHandler(files: files)
        try portkey.run(fileManager: fileHandler,
                        fileReader: fileHandler,
                        fileWriter: fileHandler)
        let updatedSourceContent = try fileHandler.read(from: sourcePath)
        let updatedDestinationContent = try fileHandler.read(from: destinationPath)
        #expect(updatedSourceContent.trimmingCharacters(in: .whitespacesAndNewlines) == sourceContent.trimmingCharacters(in: .whitespacesAndNewlines))
        #expect(updatedDestinationContent.trimmingCharacters(in: .whitespacesAndNewlines) == destinationContent.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

extension String {
    static func createStringsFile(withKey key: String, value: String) -> String {
        """
        /* example \(value) string */
        "\(key)" = "\(value)";
        """
    }

    static func createStringsFile(withEntries entries: [(String, String)]) -> String {
        entries.map { key, value in
            .createStringsFile(withKey: key, value: value)
        }
        .joined(separator: "\n")
    }

    static func createPathForLocale(_ locale: String, in directory: String) -> String {
        "\(directory)/\(locale).lproj/Localizable.strings"
    }
}
