// swift-tools-version: 6.1

import PackageDescription

let swiftVersions = [
    "main",
    "6_2",
    "6_1",
]

let currentSwiftVersion: String?
#if compiler(>=6.2)
    currentSwiftVersion = "6_2"
#elseif compiler(>=6.1)
    currentSwiftVersion = "6_1"
#elseif compiler(>=6.0)
    currentSwiftVersion = "6_0"
#else
    currentSwiftVersion = nil
#endif

let package = Package(
    name: "swift-icudata-slim",
    products: (currentSwiftVersion.map { version in
        [
            .library(
                name: "ICUDataSlim",
                targets: [
                    "ICUDataSlim_\(version)",
                ]
            ),
            .library(
                name: "ICUDataSlim_Minimal",
                targets: [
                    "ICUDataSlim_Minimal_\(version)",
                ]
            ),
        ]
    } ?? [])
        + swiftVersions.flatMap { version in
            [
                .library(
                    name: "ICUDataSlim_\(version)",
                    targets: ["ICUDataSlim_\(version)"]
                ),
                .library(
                    name: "ICUDataSlim_Minimal_\(version)",
                    targets: ["ICUDataSlim_Minimal_\(version)"]
                ),
            ]
        },
    targets: swiftVersions.flatMap { version in
        [
            .target(
                name: "ICUDataSlim_\(version)",
                path: "Sources/ICUDataSlim_\(version)/default"),
            .target(
                name: "ICUDataSlim_Minimal_\(version)",
                path: "Sources/ICUDataSlim_\(version)/minimal"),
        ]
    }
)
