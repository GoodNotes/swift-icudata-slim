// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Example",
    traits: [
        .default(enabledTraits: ["Slim"]),
        "Slim",
        "Minimal",
    ],
    dependencies: [
        .package(name: "swift-icudata-slim", path: "../"),
    ],
    targets: [
        .executableTarget(
            name: "Example",
            dependencies: [
                .product(name: "ICUDataSlim_Minimal", package: "swift-icudata-slim", condition: .when(traits: ["Minimal"])),
                .product(name: "ICUDataSlim", package: "swift-icudata-slim", condition: .when(traits: ["Slim"]))
            ]
        ),
    ]
)
