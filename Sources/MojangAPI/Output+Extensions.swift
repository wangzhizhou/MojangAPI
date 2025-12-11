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
        case .unauthorized(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 401, code: Int(err.code ?? 0), message: err.message)
        case .forbidden(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 403, code: Int(err.code ?? 0), message: err.message)
        case .tooManyRequests(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 429, code: Int(err.code ?? 0), message: err.message)
        case .internalServerError(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 500, code: Int(err.code ?? 0), message: err.message)
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
        case .unauthorized(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 401, code: Int(err.code ?? 0), message: err.message)
        case .forbidden(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 403, code: Int(err.code ?? 0), message: err.message)
        case .tooManyRequests(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 429, code: Int(err.code ?? 0), message: err.message)
        case .internalServerError(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 500, code: Int(err.code ?? 0), message: err.message)
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
        case .unauthorized(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 401, code: Int(err.code ?? 0), message: err.message)
        case .forbidden(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 403, code: Int(err.code ?? 0), message: err.message)
        case .tooManyRequests(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 429, code: Int(err.code ?? 0), message: err.message)
        case .internalServerError(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 500, code: Int(err.code ?? 0), message: err.message)
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
        case .unauthorized(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 401, code: Int(err.code ?? 0), message: err.message)
        case .forbidden(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 403, code: Int(err.code ?? 0), message: err.message)
        case .tooManyRequests(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 429, code: Int(err.code ?? 0), message: err.message)
        case .internalServerError(let e):
            let err = try e.body.json
            throw MojangAPIError.httpError(status: 500, code: Int(err.code ?? 0), message: err.message)
        case .undocumented(let status, _):
            if status == 404 { throw MojangAPIError.notFound }
            throw MojangAPIError.requestFailed(status: status)
        }
    }
}
