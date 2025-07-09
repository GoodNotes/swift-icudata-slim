// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Example",
    dependencies: [
        .package(name: "swift-icudata-slim", path: "../"),
    ],
    targets: [
        .executableTarget(
            name: "Example",
            dependencies: [
                .product(name: "ICUDataSlim", package: "swift-icudata-slim"),
            ]
        ),
    ]
)
