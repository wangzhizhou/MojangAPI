//
//  Types+.swift
//  MojangAPI
//
//  Created by wangzhizhou on 2024/12/28.
//

import Foundation

public typealias Manifest = Components.Schemas.Manifest
public typealias Version = Components.Schemas.Version
public typealias BuildType = Components.Schemas.Version._TypePayload
public typealias GameVersion = Components.Schemas.GameVersion
public typealias GameVersionAsset = Components.Schemas.GameVersionAsset
public typealias UserInfo = Components.Schemas.UserInfo

extension Version: Identifiable {
    private var packageSHA1: String? {
        guard let versionURL = Foundation.URL(string: url) else { return nil }
        // 从路径组件中查找 40 位十六进制字符串
        for comp in versionURL.pathComponents {
            if comp.count == 40 && comp.allSatisfy({
                ("0123456789abcdefABCDEF").contains($0)
            }) {
                return comp.lowercased()
            }
        }
        return nil
    }
    public var gameVersion: GameVersion? {
        get async throws {
            guard let packageSHA1 = packageSHA1 else { throw MojangAPIError.missingSHA1 }
            if let gameVersion = try await APICache.shared.getGameVersion(id: id, sha1: packageSHA1, loader: { try await Mojang.fetchPackage(id: id, sha1: packageSHA1) }) {
                return gameVersion
            }
            throw MojangAPIError.cacheMiss
        }
    }
    public var buildType: BuildType {
        return self._type
    }
}

extension Components.Schemas.GameVersion {
    
    public var assetIndexObject: GameVersionAsset? {
        get async throws {
            if let assetIndex = try await APICache.shared.getAssetIndex(id: assetIndex.id, sha1: assetIndex.sha1, loader: { try await Mojang.fetchPackage(id: assetIndex.id, sha1: assetIndex.sha1) }) {
                return assetIndex
            }
            throw MojangAPIError.cacheMiss
        }
    }
}


extension Components.Schemas.Object {
    
    public var resourceURL: URL {
        let hostURL = (try? Servers.Server4.url()) ?? Foundation.URL(string: "https://resources.download.minecraft.net")!
        let path = "\(dirName)/\(fileName)"
        if #available(macOS 13.0, *) {
            return hostURL.appending(path: path)
        } else {
            return hostURL.appendingPathComponent(path)
        }
    }
    
    public var dirName: String { String(hash.prefix(2)) }
    
    public var fileName: String { hash }
}
