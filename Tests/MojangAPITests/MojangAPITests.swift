import Testing
@testable import MojangAPI

@Test func FetchManifest() async throws {
    let response = try await Mojang.manifestClient.getManifest(.init())
    print(response)
}
