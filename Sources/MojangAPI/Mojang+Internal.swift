//
//  Mojang+Internal.swift
//  MojangAPI
//
//  Created by wangzhizhou on 2024/12/28.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// Internal
extension Mojang {
    @MainActor private static var retryCount: Int = 1
    @MainActor static func configureNetwork(retries: Int) { retryCount = max(0, retries) }
    @MainActor private static func currentRetryCount() -> Int { retryCount }

    static func withRetry<T>(_ operation: @escaping () async throws -> T) async throws -> T {
        let maxRetries = await currentRetryCount()
        var attempts = maxRetries
        do {
            return try await operation()
        } catch {
            while attempts > 0 {
                attempts -= 1
                do { return try await operation() } catch { continue }
            }
            throw error
        }
    }

    static var manifestClient: Client {
        Client(
            serverURL: (try? Servers.Server1.url()) ?? Foundation.URL(string: "https://launchermeta.mojang.com")!,
            transport: URLSessionTransport()
        )
    }
    
    static func fetchPackage(id: String, sha1: String) async throws -> Components.Schemas.Package {
        let output = try await withRetry { try await packageClient.getPackage(path: .init(sha1: sha1, id: id)) }
        return try output.jsonOrThrow()
    }
    
    // Deprecated auth client removed
    
    static var apiClient: Client {
        Client(
            serverURL: (try? Servers.Server5.url()) ?? Foundation.URL(string: "https://api.mojang.com")!,
            transport: URLSessionTransport()
        )
    }
    static var xblClient: Client {
        Client(
            serverURL: (try? Servers.Server7.url()) ?? Foundation.URL(string: "https://user.auth.xboxlive.com")!,
            transport: URLSessionTransport()
        )
    }
    static var xstsClient: Client {
        Client(
            serverURL: (try? Servers.Server8.url()) ?? Foundation.URL(string: "https://xsts.auth.xboxlive.com")!,
            transport: URLSessionTransport()
        )
    }
    static var msClient: Client {
        Client(
            serverURL: (try? Servers.Server8.url()) ?? Foundation.URL(string: "https://api.minecraftservices.com")!,
            transport: URLSessionTransport()
        )
    }
    static func msClient(withAccessToken token: String) -> Client {
        Client(
            serverURL: (try? Servers.Server8.url()) ?? Foundation.URL(string: "https://api.minecraftservices.com")!,
            configuration: .init(),
            transport: URLSessionTransport(),
            middlewares: [BearerTokenMiddleware(token: token)]
        )
    }
}

// Private
extension Mojang {
    private static var packageClient: Client {
        Client(
            serverURL: (try? Servers.Server2.url()) ?? Foundation.URL(string: "https://piston-meta.mojang.com")!,
            transport: URLSessionTransport()
        )
    }
}
