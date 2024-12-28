import Testing
import MojangAPI

@Test
func MojangAPIUsage() async throws {
    let json = try await Mojang.fetchManifest()
    #expect(json.latest.release.isEmpty == false)
    #expect(json.versions.isEmpty == false)
    
    let latestVersion = try #require(json.versions.first)
    #expect(latestVersion.url.isEmpty == false)
    
    let gameVersion = try #require(try await latestVersion.gameVersion)
    #expect(gameVersion.arguments.game.isEmpty == false)
    #expect(gameVersion.arguments.jvm.isEmpty == false)
    #expect(gameVersion.assetIndex.url.isEmpty == false)
    #expect(gameVersion.downloads.client.url.isEmpty == false)
    #expect(gameVersion.downloads.server.url.isEmpty == false)
    #expect(gameVersion.libraries.isEmpty == false)
    #expect(gameVersion.mainClass.isEmpty == false)
    
    let assetIndexObject = try #require(try await gameVersion.assetIndexObject)
    #expect(assetIndexObject.objects.additionalProperties.isEmpty == false)
}
