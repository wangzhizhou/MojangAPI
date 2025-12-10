// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MojangAPI",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "MojangAPI",
            targets: ["MojangAPI"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-openapi-generator.git",
            from: "1.10.3"
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-runtime.git",
            from: "1.9.0"
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-urlsession.git",
            from: "1.2.0"
        ),
    ],
    targets: [
        .target(
            name: "MojangAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(
                    name: "OpenAPIURLSession",
                    package: "swift-openapi-urlsession"
                ),
            ],
            plugins: [
                .plugin(
                    name: "OpenAPIGenerator",
                    package: "swift-openapi-generator"
                )
            ]
        ),
        .testTarget(
            name: "MojangAPITests",
            dependencies: ["MojangAPI"]
        ),
    ]
)
