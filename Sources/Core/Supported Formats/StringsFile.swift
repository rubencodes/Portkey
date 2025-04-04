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

    // MARK: - Lifecycle

    init?(directoryPath: String, locale: String, fileManager: FileManager) {
        let fullPath = "\(directoryPath)/\(locale)/Localizable.strings"
        guard fileManager.fileExists(atPath: fullPath) else { return nil }
        self.path = fullPath
    }

    // MARK: - Internal Functions

    func containsKey(_ key: String) -> Bool {
        guard let content = try? String(contentsOfFile: path) else { return false }
        return content.contains("\"\(key)\"")
    }

    func removeEntry(forKey key: String) throws -> String? {
        let content = try String(contentsOfFile: path)
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
                   line.trimmingCharacters(in: .whitespaces).hasPrefix("//") {
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

        try newLines.joined(separator: "\n").write(toFile: path, atomically: true, encoding: .utf8)
        return foundEntry
    }

    func appendEntry(_ entry: String) throws {
        var content = (try? String(contentsOfFile: path)) ?? ""
        if !content.hasSuffix("\n") {
            content.append("\n")
        }
        content.append("\(entry)\n")
        try content.write(toFile: path, atomically: true, encoding: .utf8)
    }
}
