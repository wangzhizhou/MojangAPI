import Foundation

public struct MicrosoftAuth {
    public static func xboxUserAuthenticate(msAccessToken: String) async throws -> (token: String, uhs: String) {
        let rps = "d=\(msAccessToken)"
        let props = Components.Schemas.XboxUserAuthenticateRequest.PropertiesPayload(authMethod: "RPS", siteName: "user.auth.xboxlive.com", rpsTicket: rps)
        let body = Components.Schemas.XboxUserAuthenticateRequest(relyingParty: "http://auth.xboxlive.com", tokenType: "JWT", properties: props)
        let output = try await Mojang.withRetry { try await Mojang.xblClient.xboxUserAuthenticate(body: Operations.XboxUserAuthenticate.Input.Body.json(body)) }
        let resp = try output.jsonOrThrow()
        let uhs = resp.displayClaims.xui.first?.uhs ?? ""
        return (resp.token, uhs)
    }

    public static func xstsAuthorize(xblToken: String) async throws -> (token: String, uhs: String) {
        let props = Components.Schemas.XstsAuthorizeRequest.PropertiesPayload(sandboxId: "RETAIL", userTokens: [xblToken])
        let body = Components.Schemas.XstsAuthorizeRequest(relyingParty: "rp://api.minecraftservices.com/", tokenType: "JWT", properties: props)
        let output = try await Mojang.withRetry { try await Mojang.xstsClient.xstsAuthorize(body: Operations.XstsAuthorize.Input.Body.json(body)) }
        let resp = try output.jsonOrThrow()
        let uhs = resp.displayClaims.xui.first?.uhs ?? ""
        return (resp.token, uhs)
    }

    public static func loginWithXbox(xstsToken: String, uhs: String) async throws -> Components.Schemas.LoginWithXboxResponse {
        let identity = "XBL3.0 x=\(uhs);\(xstsToken)"
        let body = Components.Schemas.LoginWithXboxRequest(identityToken: identity, ensureLegacyEnabled: true)
        let output = try await Mojang.withRetry { try await Mojang.msClient.loginWithXbox(body: Operations.LoginWithXbox.Input.Body.json(body)) }
        return try output.jsonOrThrow()
    }

    public static func getMinecraftProfile(accessToken: String) async throws -> Components.Schemas.MinecraftProfile {
        let client = Mojang.msClient(withAccessToken: accessToken)
        let output = try await Mojang.withRetry { try await client.getMinecraftProfile(headers: .init()) }
        return try output.jsonOrThrow()
    }

    public static func loginWithUsernamePassword(clientId: String, username: String, password: String) async throws -> Components.Schemas.MinecraftProfile {
        let msAccessToken = try await MicrosoftOAuth.usernamePasswordAccessToken(clientId: clientId, username: username, password: password)
        let (xblToken, _) = try await xboxUserAuthenticate(msAccessToken: msAccessToken)
        let (xstsToken, uhs) = try await xstsAuthorize(xblToken: xblToken)
        let login = try await loginWithXbox(xstsToken: xstsToken, uhs: uhs)
        return try await getMinecraftProfile(accessToken: login.accessToken)
    }
}
