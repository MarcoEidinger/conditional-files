// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "conditional-files",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.1.0")),
    ],
    targets: [
        .executableTarget(
            name: "conditional-files",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "conditional-files-tests",
            dependencies: ["conditional-files"],
            resources: [.copy("TestData")]
        ),
    ]
)
