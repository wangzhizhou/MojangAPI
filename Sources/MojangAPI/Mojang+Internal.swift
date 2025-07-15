//
//  Mojang+Internal.swift
//  MojangAPI
//
//  Created by wangzhizhou on 2024/12/28.
//

import OpenAPIRuntime
import OpenAPIURLSession

// Internal
extension Mojang {
    
    static let manifestClient = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport()
    )
    
    static func fetchPackage(id: String, sha1: String) async throws -> Components.Schemas.Package {
        let response = try await packageClient.getPackage(path: .init(sha1: sha1, id: id))
        return try response.ok.body.json
    }
    
    static let authClient = Client(
        serverURL: try! Servers.Server5.url(),
        transport: URLSessionTransport()
    )
    
    static let apiClient = Client(
        serverURL: try! Servers.Server6.url(),
        transport: URLSessionTransport()
    )
}

// Private
extension Mojang {
    
    private static let packageClient = Client(
        serverURL: try! Servers.Server2.url(),
        transport: URLSessionTransport()
    )
}
