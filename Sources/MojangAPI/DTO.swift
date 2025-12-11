import Foundation

/// 版本类型枚举，独立于生成类型，便于向后兼容
public enum BuildKind: String, Codable, Equatable {
    case release
    case snapshot
    case oldBeta = "old_beta"
    case oldAlpha = "old_alpha"
}

/// 基础版本信息 DTO，用于清单与查询返回
public struct VersionInfo: Codable, Equatable, Identifiable {
    public let id: String
    public let type: BuildKind
    public let url: String
}

/// 清单摘要 DTO，包含最新版本与版本列表
public struct ManifestSummary: Codable, Equatable {
    public let latestRelease: String
    public let latestSnapshot: String
    public let versions: [VersionInfo]

    public init(latestRelease: String, latestSnapshot: String, versions: [VersionInfo]) {
        self.latestRelease = latestRelease
        self.latestSnapshot = latestSnapshot
        self.versions = versions
    }

    /// 从生成的 Manifest 映射到 DTO
    public init(fromManifest m: Manifest) {
        let versions: [VersionInfo] = m.versions.map { v in
            let kind: BuildKind
            switch v._type {
            case .release: kind = .release
            case .snapshot: kind = .snapshot
            case .oldBeta: kind = .oldBeta
            case .oldAlpha: kind = .oldAlpha
            }
            return VersionInfo(id: v.id, type: kind, url: v.url)
        }
        self.init(latestRelease: m.latest.release, latestSnapshot: m.latest.snapshot, versions: versions)
    }
}

/// 用户档案 DTO，用于对外稳定返回
public struct UserProfile: Codable, Equatable {
    public let name: String
    public let id: String
}

public extension ManifestSummary {
    /// 过滤版本列表
    func filter(id: String? = nil, type: BuildKind = .release) -> [VersionInfo] {
        versions.filter { v in
            if let id { return v.type == type && v.id.contains(id) }
            return v.type == type
        }
    }
}
