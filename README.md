# MojangAPI

OpenAPI of Mojang for Minecraft: [openapi.yaml](Sources/MojangAPI/openapi.yaml)

[![][swift]][repo] [![][platform]][repo]

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

## Quick Start

```swift
import MojangAPI

// 可选：配置网络参数
Mojang.configureNetwork(timeoutRequest: 15, timeoutResource: 60, headers: ["User-Agent": "MojangAPI/1.0"], retries: 1)

// 获取清单的传输对象摘要
let summary = ManifestSummary(fromManifest: try await Mojang.manifest())
let releases = summary.filter(type: .release)

// 直接获取最新版本信息（传输对象）
let latest = try await Mojang.latestInfo(type: .release)

// 按版本过滤（传输对象）
let versions = try await Mojang.versionsInfo(id: "1.21")

// 查询用户信息（传输对象）
let profile = try await Mojang.userProfile(with: "Notch")
```

[swift]: <https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fwangzhizhou%2FMojangAPI%2Fbadge%3Ftype%3Dswift-versions>
[platform]: <https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fwangzhizhou%2FMojangAPI%2Fbadge%3Ftype%3Dplatforms>
[repo]: <https://swiftpackageindex.com/wangzhizhou/MojangAPI>