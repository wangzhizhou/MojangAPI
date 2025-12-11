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

public extension Operations.XboxUserAuthenticate.Output {
    func jsonOrThrow() throws -> Components.Schemas.XboxUserAuthenticateResponse {
        switch self {
        case .ok(let success):
            return try success.body.json
        case .undocumented(let status, _):
            if status == 404 { throw MojangAPIError.notFound }
            throw MojangAPIError.requestFailed(status: status)
        }
    }
}

public extension Operations.XstsAuthorize.Output {
    func jsonOrThrow() throws -> Components.Schemas.XstsAuthorizeResponse {
        switch self {
        case .ok(let success):
            return try success.body.json
        case .undocumented(let status, _):
            if status == 404 { throw MojangAPIError.notFound }
            throw MojangAPIError.requestFailed(status: status)
        }
    }
}

public extension Operations.LoginWithXbox.Output {
    func jsonOrThrow() throws -> Components.Schemas.LoginWithXboxResponse {
        switch self {
        case .ok(let success):
            return try success.body.json
        case .undocumented(let status, _):
            if status == 404 { throw MojangAPIError.notFound }
            throw MojangAPIError.requestFailed(status: status)
        }
    }
}

public extension Operations.GetMinecraftProfile.Output {
    func jsonOrThrow() throws -> Components.Schemas.MinecraftProfile {
        switch self {
        case .ok(let success):
            return try success.body.json
        case .undocumented(let status, _):
            if status == 404 { throw MojangAPIError.notFound }
            throw MojangAPIError.requestFailed(status: status)
        }
    }
}
