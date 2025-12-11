import Testing
import Foundation
@testable import MojangAPI

@Test
func microsoftLoginFlow() async throws {
    let env = ProcessInfo.processInfo.environment
    guard let msToken = env["MS_ACCESS_TOKEN"] else { return }
    let xbl = try await MicrosoftAuth.xboxUserAuthenticate(msAccessToken: msToken)
    let xsts = try await MicrosoftAuth.xstsAuthorize(xblToken: xbl.token)
    let login = try await MicrosoftAuth.loginWithXbox(xstsToken: xsts.token, uhs: xsts.uhs)
    let profile = try await MicrosoftAuth.getMinecraftProfile(accessToken: login.accessToken)
    #expect(!login.accessToken.isEmpty)
    #expect(!xbl.uhs.isEmpty)
    #expect(!xsts.uhs.isEmpty)
    #expect(!profile.name.isEmpty)
}
