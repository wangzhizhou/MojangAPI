import Foundation

public extension Operations.GetMinecraftGameVersionManifest.Output {
    func jsonOrThrow() throws -> Manifest {
        switch self {
        case .ok(let success):
            return try success.body.json
        case .undocumented(let status, _):
            if status == 404 { throw MojangAPIError.notFound }
            throw MojangAPIError.requestFailed(status: status)
        }
    }
}

public extension Operations.GetPackage.Output {
    func jsonOrThrow() throws -> Components.Schemas.Package {
        switch self {
        case .ok(let success):
            return try success.body.json
        case .undocumented(let status, _):
            if status == 404 { throw MojangAPIError.notFound }
            throw MojangAPIError.requestFailed(status: status)
        }
    }
}


public extension Operations.GetUserInfoWithName.Output {
    func jsonOrThrow() throws -> Components.Schemas.UserInfo {
        switch self {
        case .ok(let success):
            return try success.body.json
        case .undocumented(let status, _):
            if status == 404 { throw MojangAPIError.notFound }
            throw MojangAPIError.requestFailed(status: status)
        }
    }
}
