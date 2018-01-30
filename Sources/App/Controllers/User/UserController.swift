import Vapor
import FluentProvider

final class UserController {

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
      show: show,
      update: update
    )
  }
}

extension UserController: EmptyInitializable {}
