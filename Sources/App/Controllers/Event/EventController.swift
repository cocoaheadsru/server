import Vapor
import Fluent

final class EventController {
  
  enum Timeline {
    case beforeDate(Date)
    case afterDate(Date)
  }
  
  func index(_ request: Request) throws -> ResponseRepresentable {
    guard let query = request.query else {
      throw Abort(.badRequest, reason: "Query parameters is missing in URL request")
    }
    
    if let date = query["before"]?.date {
      return try sendEvents(.beforeDate(date), request: request)
    } else if let date = query["after"]?.date {
      return try sendEvents(.afterDate(date), request: request)
    } else {
      throw Abort(.badRequest, reason: "Query parameter is not correct in URL request")
    }
  }
    
  private func sendEvents(_ eventsTimeline: Timeline, request: Request) throws -> Response {
    let events = try fetchEvents(using: eventsTimeline)
    return try prepareJSON(for: events, with: request).makeResponse()
  }
  
  private func fetchEvents(using eventsTimeline: Timeline) throws -> [Event] {
    switch eventsTimeline {
    case .beforeDate(let date):
      return try fetchEvents(that: .lessThanOrEquals, date: date)
    case .afterDate(let date):
      return try fetchEvents(that: .greaterThanOrEquals, date: date)
    }
  }
  
  private func fetchEvents(
    that comparison: Filter.Comparison,
    date: Date
  ) throws -> [Event] {
    return try Event
      .makeQuery()
      .filter(Event.Keys.endDate, comparison, date)
      .sort(Event.Keys.startDate, .descending)
      .all()
  }
  
  private func prepareJSON(
    for events: [Event],
    with request: Request
  ) throws -> JSON {
    let jsonArray: [StructuredData] = try events.map { (event) -> StructuredData in
      try event.makeJSON(with: request).wrapped
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
