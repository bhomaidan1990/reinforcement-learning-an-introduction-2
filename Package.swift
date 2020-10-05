// swift-tools-version:5.3
import PackageDescription


let package = Package(
    name: "Reinforcement Learning - An Introduction",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "MultiArmedBandit",
            targets: ["MultiArmedBandit"]
        )
    ],
    dependencies: [
        // FIXME: Replace with DeepMind's official repo once my fixes are merged.
        .package(
            name: "OpenSpiel",
            url: "https://github.com/vojtamolda/open_spiel.git",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "MultiArmedBandit",
            dependencies: ["OpenSpiel"],
            path: "Chapter 2/MultiArmedBandit"
        ),
        .testTarget(
            name: "MultiArmedBanditTests",
            dependencies: ["MultiArmedBandit"],
            path: "Chapter 2/MultiArmedBanditTests"
        )
    ]
)
