// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HAP-IR-Demo",
    dependencies: [
        .package(url: "https://github.com/uraimo/SwiftyGPIO.git", from: "2.0.0-beta7")
    ],
    targets: [
    ]
)

#if os(macOS)
    package.dependencies.append(.package(url: "https://github.com/DianQK/pigpio-mock.git", .branch("master")))
    package.targets.append(.target(name: "HAP-IR-Demo", dependencies: ["SwiftyGPIO", "Clibpigpio"]))
#endif

#if os(Linux)
    package.dependencies.append(.package(url: "https://github.com/DianQK/Clibpigpio.git", from: "1.71.0"))
    package.targets.append(.target(name: "HAP-IR-Demo", dependencies: ["SwiftyGPIO"]))
#endif
