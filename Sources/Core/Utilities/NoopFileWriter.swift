//
//  NoopFileWriter.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

struct NoopFileWriter: FileWriting {
    func write(_: String, to _: String) throws {}
}
