import Foundation
import OpenAPIRuntime
import HTTPTypes

struct BearerTokenMiddleware: ClientMiddleware {
    let token: String
    func intercept(_ request: HTTPRequest, body: HTTPBody?, baseURL: URL, operationID: String, next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)) async throws -> (HTTPResponse, HTTPBody?) {
        var req = request
        req.headerFields[.authorization] = "Bearer \(token)"
        return try await next(req, body, baseURL)
    }
}
