//
//  CLITests.swift
//  Portkey
//
//  Created by Ruben Martinez Jr. on 4/7/25.
//

import Core
import Foundation
@testable import portkey
import Testing

struct CLITests {
    @Test func test_CreatesPortkeyFromHappyPathArguments() {
        let portkeyBasic = try? Portkey.create(from: [
            "--key=\"foo\"",
            "--from='/bar'",
            "--to=/baz",
        ])
        #expect(portkeyBasic != nil)
        #expect(portkeyBasic?.keys == ["foo"])
        #expect(portkeyBasic?.sourcePath == "/bar")
        #expect(portkeyBasic?.destinationPath == "/baz")

        let portkeyMultiple = try? Portkey.create(from: [
            "--keys=foo,\"bar\",\"baz quux\"",
            "--from=/bar",
            "--to=/baz",
        ])
        #expect(portkeyMultiple != nil)
        #expect(portkeyMultiple?.keys == ["foo", "bar", "baz quux"])
        #expect(portkeyMultiple?.sourcePath == "/bar")
        #expect(portkeyMultiple?.destinationPath == "/baz")

        let portkeyRename = try? Portkey.create(from: [
            "--key=foo",
            "--new-key=bar",
            "--from=/bar",
        ])
        #expect(portkeyRename != nil)
        #expect(portkeyRename?.keys == ["foo"])
        #expect(portkeyRename?.sourcePath == "/bar")
        #expect(portkeyRename?.newKey == "bar")
    }

    @Test func test_ThrowsFromInvalidArguments() {
        #expect(throws: Portkey.InitializationError.missingKey) {
            try Portkey.create(from: [
                "--from=/bar",
                "--to=/baz",
            ])
        }

        #expect(throws: Portkey.InitializationError.missingSourcePath) {
            try Portkey.create(from: [
                "--key=foo",
                "--to=/baz",
            ])
        }

        #expect(throws: Portkey.InitializationError.missingRequiredArguments) {
            try Portkey.create(from: [
                "--key=foo",
                "--from=/bar",
            ])
        }
    }

    @Test func test_ParsesBooleanArguments() {
        let portkeyBasic = try? Portkey.create(from: [
            "--key=foo",
            "--from=/bar",
            "--to=/baz",
            "--dry-run",
        ])
        #expect(portkeyBasic != nil)
        #expect(portkeyBasic?.keys == ["foo"])
        #expect(portkeyBasic?.sourcePath == "/bar")
        #expect(portkeyBasic?.destinationPath == "/baz")
        #expect(portkeyBasic?.isDryRun ?? false)
    }

    @Test func test_IgnoresUnrecognizedArguments() {
        let portkeyBasic = try? Portkey.create(from: [
            "--key=foo",
            "--from=/bar",
            "--to=/baz",
            "unknown-argument=bar",
        ])
        #expect(portkeyBasic != nil)
        #expect(portkeyBasic?.keys == ["foo"])
        #expect(portkeyBasic?.sourcePath == "/bar")
        #expect(portkeyBasic?.destinationPath == "/baz")
    }
}
