import Vapor
import FluentProvider
import Foundation
import Multipart

final class PushNotificationController {

  func subscribe(_ request: Request) throws -> ResponseRepresentable {

    guard
      let json = request.json,
      let pushToken = json[Client.Keys.pushToken]?.string
    else {
      throw Abort(.badRequest, reason: "Request's body no have pushToken to the push-notification registration")
    }

    if let client = try Client.returnIfExcists(request: request) {
      client.pushToken = pushToken
      try client.save()
      return client
    }

    let client = try Client(request: request)
    try client.save()

    return client
  }

  func cancel(_ request: Request, user: User) throws -> ResponseRepresentable {

    guard let client = try Client.returnIfExcists(request: request) else {
      throw Abort(
        .internalServerError,
        reason: "Not found push-notifications registration for user.id: '\(user.id?.int ?? -1)'"
      )
    }

    try client.delete()
    return try Response(.ok, message: "Push-notifications registration is canceled")
  }
}

extension PushNotificationController: ResourceRepresentable {

  func makeResource() -> Resource<User> {
    return Resource(
      store: subscribe,
      destroy: cancel
    )
  }
}

extension PushNotificationController: EmptyInitializable { }
