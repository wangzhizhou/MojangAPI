import OpenAPIRuntime
import OpenAPIURLSession

public typealias Manifest = Components.Schemas.Manifest
public typealias Version = Components.Schemas.Version

public typealias GameVersion = Components.Schemas.GameVersion
public typealias GameVersionAsset = Components.Schemas.GameVersionAsset

public struct Mojang {
    
    private static let manifestClient = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport()
    )
    
    public static func fetchManifest() async throws -> Manifest {
        let response = try await manifestClient.getMinecraftGameVersionManifest()
        return try response.ok.body.json
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

extension Version {
    private var sha1: String {
        String(url.split(separator: "/").dropLast().last!) // TODO: 写死分割号的方式存在问题，后续修改
    }
    public var gameVersion: GameVersion? {
        get async throws {
            guard case let .GameVersion(gameVersion) = try await Mojang.fetchPackage(id: id, sha1: sha1)
            else {
                return nil
            }
            return gameVersion
        }
        
    }
}

extension Components.Schemas.GameVersion {
    
    public var assetIndexObject: GameVersionAsset? {
        get async throws {
            guard case let .GameVersionAsset(gameAsset) = try await Mojang.fetchPackage(id: assetIndex.id, sha1: assetIndex.sha1)
            else {
                return nil
            }
            return gameAsset
        }
    }
}

import System

extension Components.Schemas.Object {
    
    public var dirPath: String {
        let startIndex = hash.startIndex
        let endIndex = hash.index(startIndex, offsetBy: 1)
        let path = String(hash[startIndex...endIndex])
        return path
    }

    public var filePath: String {
        let filename = hash
        let dirPath = self.dirPath
        return "\(dirPath)/\(filename)" // TODO: 改成平台兼容方式
    }
}
