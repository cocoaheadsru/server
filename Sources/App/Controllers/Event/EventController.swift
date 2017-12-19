import Vapor

final class EventController {
  
  func index(_ req: Request) throws -> ResponseRepresentable {
    guard let query = req.query else {
      return try Response(
        status: .badRequest,
        message: "Query parameters is missing in URL request"
      )
    }
    
    if let timestamp = query["before"]?.int {
      let events = try fetchEvents(before: timestamp)
      return try events.makeJSON()
    } else if let timestamp = query["after"]?.int {
      let events = try fetchEvents(after: timestamp)
      return try events.makeJSON()
    } else {
      return try Response(
        status: .badRequest,
        message: "Query parameter is not correct in URL request"
      )
    }
  }
  
  private func fetchEvents(before timestamp: Int) throws -> [Event] {
    return try Event
      .makeQuery()
      .filter("end_date", .lessThanOrEquals, timestamp)
      .sort("start_date", .descending)
      .all()
  }
  
  private func fetchEvents(after timestamp: Int) throws -> [Event] {
    return try Event
      .makeQuery()
      .filter("end_date", .greaterThanOrEquals, timestamp)
      .sort("start_date", .descending)
      .all()
  }
  
  func show(_ req: Request, event: Event) throws -> ResponseRepresentable {
    return event
  }
}

extension EventController: ResourceRepresentable {
  
  func makeResource() -> Resource<Event> {
    return Resource(
      index: index,
      show: show
    )
  }
}

extension EventController: EmptyInitializable { }