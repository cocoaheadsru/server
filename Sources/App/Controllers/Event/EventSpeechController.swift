import Vapor

final class EventSpeechController {

  func index(req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int else {
      return try Response(status: .badRequest,
                          message: "Id parameter is missing.")
    }
    guard let event = try Event.find(id) else {
      return try Response(status: .notFound,
                          message: "Event with given id not found.")
    }
    
    let speeches = try event.speeches()
    let json = try speeches.makeJSON()
    return json
  }
}

extension EventSpeechController: ResourceRepresentable {

  func makeResource() -> Resource<Event> {
    return Resource(
      index: index
    )
  }
}

extension EventSpeechController: EmptyInitializable { }

