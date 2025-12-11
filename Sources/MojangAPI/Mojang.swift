import Foundation

public struct Mojang {
    
    public static func latest(type: BuildType = .release, forceUpdate: Bool = true) async throws -> Version? {
        let manifest = try await manifest(forceUpdate: forceUpdate)
        let latestVersion = switch type {
        case .release:
            manifest.latest.release
        case .snapshot:
            manifest.latest.snapshot
        default:
            "" // TODO: old_beta、old_alpah
        }
        let latest = try await versions(id: latestVersion, type: type).first
        return latest
    }
    
    public static func versions(id: String? = nil, type: BuildType = .release, forceUpdate: Bool = true) async throws -> [Version] {
        let versions = try await manifest(forceUpdate: forceUpdate).versions.filter { version in
            if let id {
                return version.buildType == type && version.id.contains(id)
            } else {
                return version.buildType == type
            }
        }
        return versions
    }
    
    public static func manifest(forceUpdate: Bool = true) async throws -> Manifest {
        do {
            let manifestValue = try await APICache.shared.getManifest(forceUpdate: forceUpdate, ttl: manifestCacheTimeToLive) {
                let output = try await Mojang.withRetry { try await manifestClient.getMinecraftGameVersionManifest() }
                return try output.jsonOrThrow()
            }
            return manifestValue
        } catch {
            throw MojangAPIError.wrap(error)
        }
    }
    
    
    public static func userInfo(with name: String) async throws -> UserInfo {
        do {
            let output = try await Mojang.withRetry { try await apiClient.getUserInfoWithName(path: .init(username: name)) }
            return try output.jsonOrThrow()
        } catch {
            throw MojangAPIError.wrap(error)
        }
    }
    
    private static let manifestCacheTimeToLive: TimeInterval = 3600
}

public extension Mojang {
    static func latestInfo(type: BuildKind = .release, forceUpdate: Bool = true) async throws -> VersionInfo? {
        let summary = ManifestSummary(fromManifest: try await manifest(forceUpdate: forceUpdate))
        let id: String = {
            switch type {
            case .release: return summary.latestRelease
            case .snapshot: return summary.latestSnapshot
            case .oldBeta, .oldAlpha: return ""
            }
        }()
        let versions = try await versionsInfo(id: id.isEmpty ? nil : id, type: type, forceUpdate: forceUpdate)
        return versions.first
    }

    static func versionsInfo(id: String? = nil, type: BuildKind = .release, forceUpdate: Bool = true) async throws -> [VersionInfo] {
        let summary = ManifestSummary(fromManifest: try await manifest(forceUpdate: forceUpdate))
        return summary.versions.filter { v in
            if let id { return v.type == type && v.id.contains(id) }
            return v.type == type
        }
    }

    static func userProfile(with name: String) async throws -> UserProfile {
        let info = try await userInfo(with: name)
        return UserProfile(name: info.name, id: info.id)
    }
}
