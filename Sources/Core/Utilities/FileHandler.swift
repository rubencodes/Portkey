//
//  FileHandler.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

struct FileHandler: FileReading, FileWriting {
    func read(from path: String) throws -> String {
        try String(contentsOfFile: path)
    }

    func write(_ content: String, to path: String) throws {
        try content.write(toFile: path, atomically: true, encoding: .utf8)
    }
}
