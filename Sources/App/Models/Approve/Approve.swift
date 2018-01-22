import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, fromJSON, Updateable
final class Approve: Model {
  
  let storage = Storage()
  
  var visitedEvents: Int
  var skippedEvents: Int
  var forPeriodInMonths: Int
  
  init(visitedEvents: Int = 2, skippedEvents: Int = 2, forPeriodInMonths: Int = 6) {
    self.visitedEvents = visitedEvents
    self.skippedEvents = skippedEvents
    self.forPeriodInMonths = forPeriodInMonths
  }
  
// sourcery:inline:auto:Approve.AutoModelGeneratable
  init(row: Row) throws {
    visitedEvents = try row.get(Keys.visitedEvents)
    skippedEvents = try row.get(Keys.skippedEvents)
    forPeriodInMonths = try row.get(Keys.forPeriodInMonths)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.visitedEvents, visitedEvents)
    try row.set(Keys.skippedEvents, skippedEvents)
    try row.set(Keys.forPeriodInMonths, forPeriodInMonths)
    return row
  }
// sourcery:end
}
