import Foundation

public struct MicrosoftOAuth {
    public static func usernamePasswordAccessToken(clientId: String, username: String, password: String) async throws -> String {
        let url = URL(string: "https://login.microsoftonline.com/consumers/oauth2/v2.0/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyItems: [String: String] = [
            "client_id": clientId,
            "grant_type": "password",
            "scope": "XboxLive.signin offline_access",
            "username": username,
            "password": password
        ]
        let formBody = bodyItems.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" }.joined(separator: "&")
        request.httpBody = formBody.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw MojangAPIError.unknown("invalid response") }
        guard http.statusCode == 200 else { throw MojangAPIError.requestFailed(status: http.statusCode) }
        struct TokenResponse: Decodable { let access_token: String }
        let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
        return decoded.access_token
    }
}
