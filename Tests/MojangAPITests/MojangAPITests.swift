import Testing
@testable import MojangAPI

@Test func Hosts() async throws {
    // Server Host
    try #expect(Servers.Server1.url().host() == "launchermeta.mojang.com")
    try #expect(Servers.Server2.url().host() == "piston-meta.mojang.com")
    try #expect(Servers.Server3.url().host() == "libraries.minecraft.net")
    try #expect(Servers.Server4.url().host() == "resources.download.minecraft.net")
}

@Test func manifest() async throws {
    
    // Manifest
    let manifest = try await Mojang.manifest()
    #expect(!manifest.latest.release.isEmpty)
    #expect(!manifest.latest.snapshot.isEmpty)
    #expect(!manifest.versions.isEmpty)
    
    let firstVersion = try #require(manifest.versions.first)
    #expect(!firstVersion.url.isEmpty )
    
    // Game Version
    let gameVersion = try #require(try await firstVersion.gameVersion)
    #expect(gameVersion.arguments.game.isEmpty == false)
    #expect(gameVersion.arguments.jvm.isEmpty == false)
    #expect(gameVersion.assetIndex.url.isEmpty == false)
    #expect(gameVersion.downloads.client.url.isEmpty == false)
    #expect(gameVersion.downloads.server.url.isEmpty == false)
    #expect(gameVersion.libraries.isEmpty == false)
    #expect(gameVersion.mainClass.isEmpty == false)
    
    // Game Version Asset
    let assetIndexObject = try #require(try await gameVersion.assetIndexObject)
    #expect(assetIndexObject.objects.additionalProperties.isEmpty == false)
}

@Test(arguments: [
    ("1.21.4", VertionType.snapshot),
    ("1.21.4", VertionType.release),
    ("1.21.1", VertionType.snapshot),
    (nil, VertionType.oldAlpha),
    (nil, VertionType.oldBeta),
])
func versions(id: String?, type: VertionType) async throws {
    let versions = try await Mojang.versions(id: id, type: type)
    switch type {
    case .release:
        #expect(versions.first?._type == .release)
        #expect(versions.last?._type == .release)
    case .snapshot:
        #expect(versions.first?._type == .snapshot)
        #expect(versions.last?._type == .snapshot)
    case .oldBeta:
        #expect(versions.first?._type == .oldBeta)
        #expect(versions.last?._type == .oldBeta)
    case .oldAlpha:
        #expect(versions.first?._type == .oldAlpha)
        #expect(versions.last?._type == .oldAlpha)
    }
}
