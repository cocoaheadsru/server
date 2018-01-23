import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, fromJSON, Updateable
final class Approval: Model {
  
  let storage = Storage()
  
  var visitedEvents: Int
  var skippedEvents: Int
  var periodInMonths: Int
  
  init(visitedEvents: Int = 2, skippedEvents: Int = 2, periodInMonths: Int = 6) {
    self.visitedEvents = visitedEvents
    self.skippedEvents = skippedEvents
    self.periodInMonths = periodInMonths
  }

// sourcery:inline:auto:Approval.AutoModelGeneratable
  init(row: Row) throws {
    visitedEvents = try row.get(Keys.visitedEvents)
    skippedEvents = try row.get(Keys.skippedEvents)
    periodInMonths = try row.get(Keys.periodInMonths)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.visitedEvents, visitedEvents)
    try row.set(Keys.skippedEvents, skippedEvents)
    try row.set(Keys.periodInMonths, periodInMonths)
    return row
  }
// sourcery:end
}
