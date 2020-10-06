// swift-tools-version:5.3
import PackageDescription


let package = Package(
    name: "Reinforcement Learning - An Introduction",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "ReinforcementLearning",
            targets: ["MultiArmedBandit", "Dummy"]
        ),
    ],
    dependencies: [
        .package(
            name: "OpenSpiel",
            url: "https://github.com/deepmind/open_spiel.git",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "MultiArmedBandit",
            dependencies: ["OpenSpiel", "Utilities"],
            path: "Chapter 2/MultiArmedBandit"
        ),
        .testTarget(
            name: "MultiArmedBanditTests",
            dependencies: ["MultiArmedBandit"],
            path: "Chapter 2/MultiArmedBanditTests"
        ),
        .target(
            name: "Dummy",
            dependencies: ["OpenSpiel", "Utilities"],
            path: "Chapter 3/Dummy"
        ),
        .testTarget(
            name: "DummyTests",
            dependencies: ["Dummy"],
            path: "Chapter 3/DummyTests"
        ),
        .target(
            name: "Utilities",
            path: "Tests/Utilities"
        ),
        .testTarget(
            name: "UtilitiesTests",
            path: "Tests/UtilitiesTests"
        )
    ]
)
