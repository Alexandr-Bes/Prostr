// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "NetworkingTesting", targets: ["NetworkingTesting"])
    ],
    targets: [
        .target(name: "Networking"),
        .target(
            name: "NetworkingTesting",
            dependencies: ["Networking"]
        )
    ]
)
