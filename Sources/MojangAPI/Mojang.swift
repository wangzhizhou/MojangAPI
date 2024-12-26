import OpenAPIRuntime
import OpenAPIURLSession

public struct Mojang {
    public static let manifestClient = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport()
    )
    
    public static let gameInfoClient = Client(
        serverURL: try! Servers.Server2.url(),
        transport: URLSessionTransport()
    )
}
