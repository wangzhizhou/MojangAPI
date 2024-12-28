# MojangAPI

OpenAPI of Mojang for Minecraft: [openapi.yaml](Sources/MojangAPI/openapi.yaml)

your can use this api to fetch minecraft related info about: 
- version
- library
- assets

you can make your own minecraft launcher if you understand java and launcher workflow

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

check the tests for usage example: [MojangAPITests](Tests/MojangAPITests/MojangAPITests.swift)
