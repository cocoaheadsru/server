import Vapor
import HTTP

final class AppMiddleware: Middleware {
  let token: String
  init(_ token: String) {
    self.token = token
  }
  
  func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    guard request.headers["app-token"] == token else {
      return Response(status: .unauthorized)
    }
    
    return try next.respond(to: request)
  }
}

extension AppMiddleware: ConfigInitializable {
  convenience init(config: Config) throws {
    guard let token = config["server", "app-token"]?.string, !token.isEmpty else {
      throw MiddlewareError.missingAppToken
    }
    self.init(token)
  }
}
