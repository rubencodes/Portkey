//
//  FileManaging.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/7/25.
//

import Foundation

public protocol FileManaging {
    func fileExists(at path: String) -> Bool
    func contents(of directory: String) throws -> [String]
}
