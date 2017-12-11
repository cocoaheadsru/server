import Vapor
import HTTP

final class ClientMiddleware: Middleware {
  let token: String
  init(_ token: String) {
    self.token = token
  }

  func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    guard request.headers[Constants.Header.Key.clientToken] == token else {
      return Response(status: .unauthorized)
    }

    return try next.respond(to: request)
  }
}

extension ClientMiddleware: ConfigInitializable {
  convenience init(config: Config) throws {
    let constants = Constants.Config.self
    if let token = config[constants.server, constants.clientToken]?.string.ifNotEmpty {
      self.init(token)
    } else {
      throw MiddlewareError.missingClientToken
    }
  }
}
