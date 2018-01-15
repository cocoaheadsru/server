import Vapor
import Fluent

final class EventController {
  
  enum Timeline {
    case beforeDate(Date)
    case afterDate(Date)
  }
  
  func index(_ req: Request) throws -> ResponseRepresentable {
    guard let query = req.query else {
      return try Response(
        status: .badRequest,
        message: "Query parameters is missing in URL request"
      )
    }
    
    if let date = query["before"]?.date {
      return try sendEvents(.beforeDate(date), req: req)
    } else if let date = query["after"]?.date {
      return try sendEvents(.afterDate(date), req: req)
    } else {
      return try Response(
        status: .badRequest,
        message: "Query parameter is not correct in URL request"
      )
    }
  }
    
  private func sendEvents(_ eventsTimeline: Timeline, req: Request) throws -> Response {
    let events = try fetchEvents(using: eventsTimeline)
    return try prepareJSON(for: events, with: req).makeResponse()
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
