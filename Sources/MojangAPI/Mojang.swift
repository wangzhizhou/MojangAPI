import OpenAPIRuntime
import OpenAPIURLSession

public struct Mojang {
    
    private static let manifestClient = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport()
    )
    
    public static func fetchManifest() async throws -> Components.Schemas.Manifest {
        let response = try await manifestClient.getMinecraftGameVersionManifest()
        return try response.ok.body.json
    }
    
    public static func gameVersion(of version: Components.Schemas.Version) async throws -> Components.Schemas.GameVersion? {
        guard case let .GameVersion(gameVersion) = try await fetchPackage(id: version.id, sha1: version.sha1)
        else {
            return nil
        }
        return gameVersion
    }
}

extension Mojang {
    
    private static let packageClient = Client(
        serverURL: try! Servers.Server2.url(),
        transport: URLSessionTransport()
    )
    
    static func fetchPackage(id: String, sha1: String) async throws -> Components.Schemas.Package {
        let response = try await packageClient.getPackage(path: .init(sha1: sha1, id: id))
        return try response.ok.body.json
    }
}

extension Components.Schemas.Version {
    public var sha1: String {
        String(url.split(separator: "/").dropLast().last!)
    }
}

extension Components.Schemas.GameVersion {
    
    public var assetIndexObject: Components.Schemas.GameVersionAsset? {
        get async throws {
            guard let assetId = assetIndex.id,
                  case let .GameVersionAsset(gameAsset) = try await Mojang.fetchPackage(id: assetId, sha1: assetIndex.sha1)
            else {
                return nil
            }
            return gameAsset
        }
    }
}
