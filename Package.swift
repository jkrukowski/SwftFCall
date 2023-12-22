// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swift-fcall",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "SwiftFCall", targets: ["SwiftFCall"]),
        .executable(name: "swift-fcall", targets: ["SwiftFCallCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.5"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.19.0"),
        .package(url: "https://github.com/stencilproject/Stencil", from: "0.15.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.3")
    ],
    targets: [
        .executableTarget(
            name: "SwiftFCallCLI",
            dependencies: [
                .target(name: "SwiftFCall"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log")
            ],
            plugins: [
                .plugin(
                    name: "SwiftFormat",
                    package: "SwiftFormat"
                )
            ]
        ),
        .target(
            name: "SwiftFCall",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Stencil", package: "Stencil"),
                .product(name: "Logging", package: "swift-log")
            ],
            resources: [
                .copy("Templates/prompt.stencil")
            ],
            plugins: [
                .plugin(
                    name: "SwiftFormat",
                    package: "SwiftFormat"
                )
            ]
        ),
        .testTarget(
            name: "SwiftFCallTests",
            dependencies: [
                .target(name: "SwiftFCall")
            ],
            plugins: [
                .plugin(
                    name: "SwiftFormat",
                    package: "SwiftFormat"
                )
            ]
        )
    ]
)
