import Testing
import MojangAPI

@Test
func fetchManifest() async throws {
    let json = try await Mojang.fetchManifest()
    try #require(json.latest?.release?.isEmpty == false)
    try #require(json.versions?.isEmpty == false)
    try #require(json.versions?.first?.url?.isEmpty == false)
}



@Test(arguments: [
    ("1.21.4", "a3bcba436caa849622fd7e1e5b89489ed6c9ac63"),
    ("19", "87954e1d978096bd2cb1cd5a507a55fe25690a51"),
])
func fetchPackageInfo(id: String, sha1: String) async throws {
    let response = try await Mojang.fetchPackage(id: id, sha1: sha1)
    switch response {
    case .Minecraft(let minecraft):
        try #require(minecraft.arguments?.game?.isEmpty == false)
        try #require(minecraft.arguments?.jvm?.isEmpty == false)
        try #require(minecraft.assetIndex?.url?.isEmpty == false)
        try #require(minecraft.downloads?.client?.url.isEmpty == false)
        try #require(minecraft.downloads?.server?.url.isEmpty == false)
        try #require(minecraft.libraries?.isEmpty == false)
        try #require(minecraft.mainClass?.isEmpty == false)
    case .Resource(let resources):
        try #require(resources.objects?.value.isEmpty == false)
    }
}
