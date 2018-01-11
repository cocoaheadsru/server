import Vapor
import Fluent

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
      let json = try prepareJSON(for: events, with: req)
      return try json.makeResponse()
    } else if let timestamp = query["after"]?.int {
      let events = try fetchEvents(after: timestamp)
      let json = try prepareJSON(for: events, with: req)
      return try json.makeResponse()
    } else {
      return try Response(
        status: .badRequest,
        message: "Query parameter is not correct in URL request"
      )
    }
  }
  
  private func fetchEvents(before timestamp: Int) throws -> [Event] {
    return try fetchEvents(that: .lessThanOrEquals, timestamp: timestamp)
  }
  
  private func fetchEvents(after timestamp: Int) throws -> [Event] {
    return try fetchEvents(that: .greaterThanOrEquals, timestamp: timestamp)
  }
  
  private func fetchEvents(
    that comparison: Filter.Comparison,
    timestamp: Int
  ) throws -> [Event] {
    return try Event
      .makeQuery()
      .filter(Event.Keys.endDate, comparison, timestamp)
      .sort(Event.Keys.startDate, .descending)
      .all()
  }
  
  private func prepareJSON(
    for events: [Event],
    with req: Request
  ) throws -> JSON {
    let jsonArray: [StructuredData] = try events.map {
      try $0.makeJSON(with: req).wrapped
    }
    return JSON(.array(jsonArray))
  }
}

extension EventController: ResourceRepresentable {
  
  func makeResource() -> Resource<Event> {
    return Resource(
      index: index
    )
  }
}

extension EventController: EmptyInitializable { }
