// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Portkey",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-testing.git", branch: "main"),
    ],
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
        .testTarget(
            name: "PortkeyTests",
            dependencies: [
                "portkey",
                "Core",
                .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Tests"
        ),
    ]
)
