//
//  LocalizationFile.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/4/25.
//

import Foundation

protocol LocalizationFile {
    var path: String { get }
    init?(directoryPath: String, locale: String, fileManager: FileManaging, fileReader: FileReading, fileWriter: FileWriting)
    func containsKey(_ key: String) -> Bool
    func removeEntry(forKey key: String) throws -> String?
    func appendEntry(_ entry: String) throws
}
