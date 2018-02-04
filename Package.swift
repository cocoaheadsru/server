// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "server",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/vapor/mysql-provider.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/validation-provider.git", .upToNextMajor(from: "1.1.1")),
        .package(url: "https://github.com/vapor/auth-provider.git", .upToNextMajor(from: "1.2.0"))
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentProvider", "MySQLProvider", "AuthProvider"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources"
                ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "Testing"])
    ]
)
