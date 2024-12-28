import Testing
import MojangAPI

@Test
func fetchManifest() async throws {
    let json = try await Mojang.fetchManifest()
    try #require(json.latest.release.isEmpty == false)
    try #require(json.versions.isEmpty == false)
    try #require(json.versions.first?.url.isEmpty == false)
}

@Test(arguments: [
    ("1.21.4", "a3bcba436caa849622fd7e1e5b89489ed6c9ac63"), // fetch game version package info
    ("19", "87954e1d978096bd2cb1cd5a507a55fe25690a51"),     // fetch game version package assetIndex info
])
func fetchPackageInfo(id: String, sha1: String) async throws {
    let response = try await Mojang.fetchPackage(id: id, sha1: sha1)
    switch response {
    case .GameVersion(let gameVersion):
        try #require(gameVersion.arguments.game.isEmpty == false)
        try #require(gameVersion.arguments.jvm.isEmpty == false)
        try #require(gameVersion.assetIndex.url.isEmpty == false)
        try #require(gameVersion.downloads.client.url.isEmpty == false)
        try #require(gameVersion.downloads.server.url.isEmpty == false)
        try #require(gameVersion.libraries.isEmpty == false)
        try #require(gameVersion.mainClass.isEmpty == false)
    case .GameVersionAsset(let asset):
        try #require(asset.objects.value.isEmpty == false)
    }
}
