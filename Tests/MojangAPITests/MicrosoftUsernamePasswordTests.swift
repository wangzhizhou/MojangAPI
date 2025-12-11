import Testing
import Foundation
@testable import MojangAPI

@Test
func microsoftUsernamePasswordLoginFlow() async throws {
    let env = ProcessInfo.processInfo.environment
    guard let clientId = env["MS_CLIENT_ID"], let username = env["MS_USERNAME"], let password = env["MS_PASSWORD"] else { return }
    let profile = try await MicrosoftAuth.loginWithUsernamePassword(clientId: clientId, username: username, password: password)
    #expect(!profile.name.isEmpty)
}
