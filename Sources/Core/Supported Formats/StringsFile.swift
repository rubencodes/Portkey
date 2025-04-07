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
          fileManager: FileManaging,
          fileReader: FileReading,
          fileWriter: FileWriting)
    {
        let fullPath = "\(directoryPath)/\(locale)/Localizable.strings"
        guard fileManager.fileExists(at: fullPath) else { return nil }
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
        let linesReversed = lines.reversed()
        var linesWithoutEntry: [String] = []
        var entryLines: [String] = []

        var isMatchingEntry = false
        for line in linesReversed {
            // Check if this is the entry we're looking for.
            guard isEntry(line, forKey: key) else {
                // Check if we're currently capturing an entry (and that we haven't reached a new entry).
                guard isMatchingEntry, isEntry(line) == false else {
                    // Stop capturing any entries, and prepend content to the new file buffer.
                    isMatchingEntry = false
                    linesWithoutEntry = [line] + linesWithoutEntry
                    continue
                }

                // Prepend line to the entry buffer.
                entryLines = [line] + entryLines
                continue
            }

            // Start capturing the entry, and prepend it to the entry buffer.
            isMatchingEntry = true
            entryLines = [line]
        }

        try fileWriter.write(linesWithoutEntry.joined(separator: "\n"), to: path)
        return entryLines.joined(separator: "\n")
    }

    func appendEntry(_ entry: String) throws {
        var content = (try? fileReader.read(from: path)) ?? ""
        if !content.hasSuffix("\n") {
            content.append("\n")
        }
        content.append("\(entry)\n")
        try fileWriter.write(content, to: path)
    }

    // MARK: - Private Functions

    private func isComment(_ line: String) -> Bool {
        line.trimmingCharacters(in: .whitespaces).hasPrefix("/*") || line.trimmingCharacters(in: .whitespaces).hasPrefix("//")
    }

    private func isEntry(_ line: String) -> Bool {
        isComment(line) == false && line.contains(#/.*=.*;/#)
    }

    private func isEntry(_ line: String, forKey key: String) -> Bool {
        isEntry(line) && line.trimmingCharacters(in: .whitespaces).hasPrefix("\"\(key)\"")
    }
}
