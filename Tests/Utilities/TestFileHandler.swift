//
//  TestFileHandler.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/7/25.
//

import Core
import Foundation

final class TestFileHandler: FileManaging, FileReading, FileWriting {
    enum TestFileHandlerError: Error {
        case fileNotFound
    }

    var files: [String: String] = [:]

    init(files: [String: String]) {
        self.files = files
    }

    func fileExists(at path: String) -> Bool {
        files[path] != nil
    }

    func contents(of directory: String) throws -> [String] {
        let directoryComponents = directory.split(separator: "/")
        return files.keys.filter { $0.hasPrefix(directory) }.map {
            // Remove additional path components:
            let matchedComponents = $0.split(separator: "/")
            return matchedComponents
                .prefix(through: matchedComponents.index(matchedComponents.startIndex, offsetBy: directoryComponents.count))
                .suffix(1)
                .joined(separator: "/")
        }
    }

    func read(from path: String) throws -> String {
        guard let value = files[path] else {
            throw TestFileHandlerError.fileNotFound
        }

        return value
    }

    func write(_ content: String, to path: String) throws {
        files[path] = content
    }
}
