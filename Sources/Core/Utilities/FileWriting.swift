//
//  FileWriting.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

protocol FileWriting {
    func write(_ content: String, to path: String) throws
}
