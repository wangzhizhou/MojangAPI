# MojangAPI

OpenAPI of Mojang for Minecraft: [openapi.yaml](Sources/MojangAPI/openapi.yaml)

[![][swift][repo][![][platform][repo]

## Usage

```swift
import PackageDescription
let package = Package(    
    dependencies: [
        .package(
            url: "https://github.com/wangzhizhou/MojangAPI.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "<Your Target Name>",
            dependencies: ["MojangAPI"]
        )
    ]
)
```

check the tests to learn usage of this api: [MojangAPITests](Tests/MojangAPITests/MojangAPITests.swift)

- [swift]: <https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fwangzhizhou%2FMojangAPI%2Fbadge%3Ftype%3Dswift-versions>
- [platform]: <https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fwangzhizhou%2FMojangAPI%2Fbadge%3Ftype%3Dplatforms>
- [repo]: <https://swiftpackageindex.com/wangzhizhou/MojangAPI>
