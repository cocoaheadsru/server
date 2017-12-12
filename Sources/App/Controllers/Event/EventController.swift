import Vapor

final class EventController {
  
  func show(_ req: Request, event: Event) throws -> ResponseRepresentable {
    return event
  }
}

extension EventController: ResourceRepresentable {
  
  func makeResource() -> Resource<Event> {
    return Resource(
      show: show
    )
  }
}

extension EventController: EmptyInitializable { }
