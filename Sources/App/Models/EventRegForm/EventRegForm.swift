import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class EventRegForm: Model {
  
  let storage = Storage()
  
  // sourcery: relatedModel = Event
  var eventId: Identifier
  var formName: String
  var description: String
  
  init(eventId: Identifier, formName: String, description: String) {
    self.eventId = eventId
    self.formName = formName
    self.description = description
  }
  
  // sourcery:inline:auto:EventRegForm.AutoModelGeneratable
  init(row: Row) throws {
    eventId = try row.get(Keys.eventId)
    formName = try row.get(Keys.formName)
    description = try row.get(Keys.description)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.eventId, eventId)
    try row.set(Keys.formName, formName)
    try row.set(Keys.description, description)
    return row
  }
  // sourcery:end
}
