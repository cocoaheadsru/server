import Vapor

final class UserUnauthorizedController {

  func store(_ request: Request) throws -> ResponseRepresentable {
    guard let json = request.json else {
      throw Abort(.badRequest, reason: "Empty or invalid body")
    }
    let user = try User(json: json)
    try user.save()
    return user
  }
}

extension UserUnauthorizedController: ResourceRepresentable {

  func makeResource() -> Resource<User> {
    return Resource(
      store: store
    )
  }
}

extension UserUnauthorizedController: EmptyInitializable {}
