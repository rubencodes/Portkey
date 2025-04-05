//
//  NoopFileHandler.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

struct NoopFileHandler: FileReading, FileWriting {
    private let data: [String: String]

    init(data: [String: String] = [:]) {
        self.data = data
    }

    func read(from path: String) throws -> String {
        data[path] ?? ""
    }

    func write(_: String, to _: String) throws {}
}
