//
//  Types+.swift
//  MojangAPI
//
//  Created by wangzhizhou on 2024/12/28.
//

import Foundation

public typealias Manifest = Components.Schemas.Manifest
public typealias Version = Components.Schemas.Version
public typealias GameVersion = Components.Schemas.GameVersion
public typealias GameVersionAsset = Components.Schemas.GameVersionAsset
public typealias VertionType = Components.Schemas.Version._TypePayload

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


extension Components.Schemas.Object {
    
    public var URL: URL {
        let hostURL = try! Servers.Server4.url()
        if #available(macOS 13.0, *) {
            return hostURL.appending(path: hash)
        } else {
            return hostURL.appendingPathComponent(hash)
        }
    }
    
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

extension String {
    var asURL: URL? { URL(string: self) }
}
