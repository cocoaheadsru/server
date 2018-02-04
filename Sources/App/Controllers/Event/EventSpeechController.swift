import Vapor

final class EventSpeechController {

  func index(req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int else {
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
