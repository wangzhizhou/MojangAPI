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

// 可选：配置重试次数
Mojang.configureNetwork(retries: 1)

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

## 微软授权流程

### 令牌模式（推荐，已获微软 OAuth Access Token）

环境变量（测试用例会自动读取并执行，否则跳过）：
- `MS_ACCESS_TOKEN`

调用示例：
```swift
import MojangAPI

let msAccessToken = ProcessInfo.processInfo.environment["MS_ACCESS_TOKEN"]!
let (xblToken, _) = try await MicrosoftAuth.xboxUserAuthenticate(msAccessToken: msAccessToken)
let (xstsToken, uhs) = try await MicrosoftAuth.xstsAuthorize(xblToken: xblToken)
let login = try await MicrosoftAuth.loginWithXbox(xstsToken: xstsToken, uhs: uhs)
let profile = try await MicrosoftAuth.getMinecraftProfile(accessToken: login.accessToken)
```

### 用户名密码模式（ROPC）

说明：使用微软消费者租户的“资源所有者密码凭据（ROPC）”流程，需确保客户端允许该授权方式且账号场景支持。

环境变量（测试用例会自动读取并执行，否则跳过）：
- `MS_CLIENT_ID`
- `MS_USERNAME`
- `MS_PASSWORD`

调用示例：
```swift
import MojangAPI

let clientId = ProcessInfo.processInfo.environment["MS_CLIENT_ID"]!
let username  = ProcessInfo.processInfo.environment["MS_USERNAME"]!
let password  = ProcessInfo.processInfo.environment["MS_PASSWORD"]!

let profile = try await MicrosoftAuth.loginWithUsernamePassword(clientId: clientId, username: username, password: password)
```

### 注意事项
- 未设置上述环境变量时，相关集成测试默认跳过，不会失败。
- 网络错误已统一抛出 `MojangAPIError`（区分 404 与非 200 响应），便于排查。
- `GET /minecraft/profile` 的鉴权通过中间件自动注入 `Authorization: Bearer <token>`。
