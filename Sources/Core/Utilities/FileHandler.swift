//
//  FileHandler.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

public struct FileHandler: FileManaging, FileReading, FileWriting {
    public init() {}

    public func fileExists(at path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }

    public func contents(of directory: String) throws -> [String] {
        try FileManager.default.contentsOfDirectory(atPath: directory)
    }

    public func read(from path: String) throws -> String {
        try String(contentsOfFile: path)
    }

    public func write(_ content: String, to path: String) throws {
        try content.write(toFile: path, atomically: true, encoding: .utf8)
    }
}
