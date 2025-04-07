//
//  PortkeyError.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/5/25.
//

import Foundation

public enum PortkeyError: Error {
    case failedToFindSourceFiles
    case failedToFindMatchingDestinationFile
    case keyCollisionAtDestination
}
