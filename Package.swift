// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Portkey",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "portkey",
            dependencies: ["Core"],
            path: "Sources/Main"
        ),
        .target(
            name: "Core",
            dependencies: []
        ),
    ]
)

