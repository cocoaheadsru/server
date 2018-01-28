import Vapor
import FluentProvider

final class UserController {
  
  func store(_ request: Request) throws -> ResponseRepresentable {
    guard let json = request.json else {
      throw Abort(.badRequest, reason: "Empty or invalid body")
    }
    let user = try User(json: json)
    try user.save()
    return user
  }
  
  func show(_ request: Request, user: User) throws -> ResponseRepresentable {
    do {
      try user.updateSessionToken()
    } catch {
      throw Abort.badRequest
    }
    return user
  }
  
  func update(_ request: Request, user: User) throws -> ResponseRepresentable {
    try user.update(for: request)
    try user.save()
    return user
  }
}

extension UserController: ResourceRepresentable {
  
  func makeResource() -> Resource<User> {
    return Resource(
      store: store,
      show: show,
      update: update
    )
  }
}

extension UserController: EmptyInitializable {}
