//
//  FileReading.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

protocol FileReading {
    func read(from path: String) throws -> String
}
