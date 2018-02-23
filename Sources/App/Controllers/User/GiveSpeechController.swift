import Vapor
import FluentProvider
import Foundation
import Multipart

final class GiveSpeechController {

  func subscribe(_ request: Request) throws -> ResponseRepresentable {

    guard
      let json = request.json,
      let title = json[GiveSpeech.Keys.title]?.string,
      let desciption = json[GiveSpeech.Keys.description]?.string
    else {
        throw Abort(.badRequest, reason: "Request's body no have `title` or `desciption` fields to give speech")
    }

    let user = try request.user()
    let giveSpeech = GiveSpeech(
      title: title,
      description: desciption,
      userId: user.id!)
    try giveSpeech.save()

    return giveSpeech
  }

}

extension GiveSpeechController: ResourceRepresentable {

  func makeResource() -> Resource<GiveSpeech> {
    return Resource(
      store: subscribe
    )
  }
}

extension GiveSpeechController: EmptyInitializable { }
