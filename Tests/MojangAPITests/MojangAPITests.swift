import Testing
import MojangAPI

@Test func Hosts() async throws {
    // Server Host
    try #expect(Servers.Server1.url().host() == "launchermeta.mojang.com")
    try #expect(Servers.Server2.url().host() == "piston-meta.mojang.com")
    try #expect(Servers.Server3.url().host() == "libraries.minecraft.net")
    try #expect(Servers.Server4.url().host() == "resources.download.minecraft.net")
    try #expect(Servers.Server5.url().host() == "authserver.mojang.com")
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
    ("1.21.4", BuildType.snapshot),
    ("1.21.4", BuildType.release),
    ("1.21.1", BuildType.snapshot),
    (nil, BuildType.oldAlpha),
    (nil, BuildType.oldBeta),
])
func versions(id: String?, type: BuildType) async throws {
    let versions = try await Mojang.versions(id: id, type: type)
    switch type {
    case .release:
        #expect(versions.first?.buildType == .release)
        #expect(versions.last?.buildType == .release)
    case .snapshot:
        #expect(versions.first?.buildType == .snapshot)
        #expect(versions.last?.buildType == .snapshot)
    case .oldBeta:
        #expect(versions.first?.buildType == .oldBeta)
        #expect(versions.last?.buildType == .oldBeta)
    case .oldAlpha:
        #expect(versions.first?.buildType == .oldAlpha)
        #expect(versions.last?.buildType == .oldAlpha)
    }
}

@Test
func authenticate() async throws {
    let agent = Components.Schemas.Agent(name: "minecraft", version: 1)
    let username = "<microsoft_account_name>"
    let password = "<microsoft_account_password>"
    let body = Components.Schemas.AuthReqParam(agent: agent, username: username, password: password)
    let response = try await Mojang.auth(action: .authenticate, reqBody: .json(body))
    #expect(!response.accessToken.isEmpty)
    #expect(!response.clientToken.isEmpty)
}
