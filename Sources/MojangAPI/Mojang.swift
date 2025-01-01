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
        if let cachedManifest, !forceUpdate {
            return cachedManifest
        } else {
            let response = try await manifestClient.getMinecraftGameVersionManifest()
            let remoteManifest = try response.ok.body.json
            cachedManifest = remoteManifest
            return remoteManifest
        }
    }
    
    public static func auth(action: AuthAction, reqBody: AuthReqBody) async throws -> AuthRespone {
        let response = try await authClient.auth(path: .init(auth: action), body: reqBody)
        return try response.ok.body.json
        
    }
    
    nonisolated(unsafe) private static var cachedManifest: Manifest? = nil
}
