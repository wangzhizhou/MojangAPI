import Testing
import Foundation
@testable import MojangAPI

@Test
func decodeManifestSummaryFromFixtureFile() throws {
    guard let url = Bundle.module.url(forResource: "manifest", withExtension: "json") else {
        throw MojangAPIError.notFound
    }
    let data = try Data(contentsOf: url)
    let summary = try JSONDecoder().decode(ManifestSummary.self, from: data)
    #expect(!summary.latestRelease.isEmpty)
    #expect(!summary.latestSnapshot.isEmpty)
    #expect(!summary.versions.isEmpty)
    #expect(summary.versions.first?.type == .release || summary.versions.first?.type == .snapshot)
}

@Test
func decodeUserProfileFromFixtureFile() throws {
    guard let url = Bundle.module.url(forResource: "user_notch", withExtension: "json") else {
        throw MojangAPIError.notFound
    }
    let data = try Data(contentsOf: url)
    let profile = try JSONDecoder().decode(UserProfile.self, from: data)
    #expect(profile.name == "Notch")
    #expect(profile.id == "069a79f444e94726a5befca90e38aaf5")
}
