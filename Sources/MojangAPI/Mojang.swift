import OpenAPIRuntime
import OpenAPIURLSession

public struct Mojang {
    
    public static func fetchManifest() async throws -> Components.Schemas.Manifest {
        let response = try await manifestClient.getMinecraftGameVersionManifest()
        return try response.ok.body.json
    }
    
    public static func fetchPackage(id: String, sha1: String) async throws -> Components.Schemas.Package {
        let response = try await packageClient.getPackage(path: .init(id: id, sha1: sha1))
        return try response.ok.body.json
    }
}

extension Mojang {
    
    private static let manifestClient = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport()
    )
    
    private static let packageClient = Client(
        serverURL: try! Servers.Server2.url(),
        transport: URLSessionTransport()
    )
}
