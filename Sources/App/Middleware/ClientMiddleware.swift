import Vapor
import HTTP

final class ClientMiddleware: Middleware {
  let token: String
  init(_ token: String) {
    self.token = token
  }

  func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    guard request.headers["client-token"] == token else {
      return Response(status: .unauthorized)
    }

    return try next.respond(to: request)
  }
}

extension ClientMiddleware: ConfigInitializable {
  convenience init(config: Config) throws {
    guard let token = config["server", "client-token"]?.string, !token.isEmpty else {
      throw MiddlewareError.missingClientToken
    }
    self.init(token)
  }
}
