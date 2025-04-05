//
//  StringsFile.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/4/25.
//

import Foundation

struct StringsFile: LocalizationFile {
    // MARK: - Internal Properties

    let path: String

    // MARK: - Private Properties

    private let fileReader: FileReading
    private let fileWriter: FileWriting

    // MARK: - Lifecycle

    init?(directoryPath: String,
          locale: String,
          fileManager: FileManager,
          fileReader: FileReading,
          fileWriter: FileWriting)
    {
        let fullPath = "\(directoryPath)/\(locale)/Localizable.strings"
        guard fileManager.fileExists(atPath: fullPath) else { return nil }
        path = fullPath
        self.fileReader = fileReader
        self.fileWriter = fileWriter
    }

    // MARK: - Internal Functions

    func containsKey(_ key: String) -> Bool {
        guard let content = try? fileReader.read(from: path) else { return false }
        return content.contains("\"\(key)\"")
    }

    func removeEntry(forKey key: String) throws -> String? {
        let content = try fileReader.read(from: path)
        let lines = content.components(separatedBy: .newlines)
        var newLines: [String] = []
        var buffer: [String] = []
        var foundEntry: String?

        for line in lines {
            if line.contains("\"\(key)\"") && line.contains("=") {
                if !buffer.isEmpty {
                    buffer.append(line)
                    foundEntry = buffer.joined(separator: "\n")
                    buffer.removeAll()
                } else {
                    foundEntry = line
                }
            } else {
                if line.trimmingCharacters(in: .whitespaces).hasPrefix("/*") ||
                    line.trimmingCharacters(in: .whitespaces).hasPrefix("//")
                {
                    buffer = [line]
                } else {
                    if !buffer.isEmpty {
                        newLines.append(contentsOf: buffer)
                        buffer.removeAll()
                    }
                    newLines.append(line)
                }
            }
        }

        try fileWriter.write(newLines.joined(separator: "\n"), to: path)
        return foundEntry
    }

    func appendEntry(_ entry: String) throws {
        var content = (try? fileReader.read(from: path)) ?? ""
        if !content.hasSuffix("\n") {
            content.append("\n")
        }
        content.append("\(entry)\n")
        try fileWriter.write(content, to: path)
    }
}
