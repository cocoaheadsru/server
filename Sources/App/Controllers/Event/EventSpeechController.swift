import Vapor

final class EventSpeechController {

  func index(request: Request) throws -> ResponseRepresentable {
    guard let id = request.parameters["id"]?.int else {
      throw Abort(.badRequest, reason: "Id parameter is missing.")
    }
    guard let event = try Event.find(id) else {
      throw Abort(.notFound, reason: "Event with given id not found.")
    }
    
    let speeches = try event.speeches()
    return try speeches.makeJSON()
  }
}

extension EventSpeechController: ResourceRepresentable {

  func makeResource() -> Resource<Speech> {
    return Resource(
      index: index
    )
  }
}

extension EventSpeechController: EmptyInitializable { }
