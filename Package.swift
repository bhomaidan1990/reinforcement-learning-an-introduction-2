// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MultiArmedBandit",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // FIXME: Replace with DeepMind's official repo once my fixes are merged.
        .package(name: "OpenSpiel", url: "https://github.com/vojtamolda/open_spiel.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MultiArmedBandit",
            dependencies: ["OpenSpiel"])
    ]
)
