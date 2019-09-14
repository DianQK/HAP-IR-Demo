// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HAP-IR-Demo",
    dependencies: [
        .package(url: "https://github.com/uraimo/SwiftyGPIO.git", from: "2.0.0-beta7")
    ],
    targets: [
        .target(
            name: "HAP-IR-Demo",
            dependencies: ["SwiftyGPIO"])
    ]
)
