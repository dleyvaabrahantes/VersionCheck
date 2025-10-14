// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VersionCheck",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "VersionCheck",
            targets: ["VersionCheck"]
        ),
    ],
    targets: [
        .target(
            name: "VersionCheck",
            dependencies: [],
            path: "Sources/VersionCheck",
            resources: [
                .process("Media.xcassets")
            ]
        )
        
    ]
)
