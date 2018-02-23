import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Speech: Model {
    
  let storage = Storage()
  
  // sourcery: ignoreInJSON
  var eventId: Identifier
  var title: String?
  var description: String
  
  init(eventId: Identifier,
       title: String?,
       description: String) {
    self.eventId = eventId
    self.title = title
    self.description = description
  }
  
  // sourcery:inline:auto:Speech.AutoModelGeneratable
  init(row: Row) throws {
    eventId = try row.get(Keys.eventId)
    title = try? row.get(Keys.title)
    description = try row.get(Keys.description)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.eventId, eventId)
    try? row.set(Keys.title, title)
    try row.set(Keys.description, description)
    return row
  }
  // sourcery:end
}

extension Speech {

  func event() throws -> Event? {
    return try parent(id: eventId).get()
  }
  
  // sourcery: nestedJSONRepresentableField
  func speakers() throws -> [Speaker] {
    return try children().all()
  }
  
  // sourcery: nestedJSONRepresentableField
  func contents() throws -> [Content] {
    return try children().all()
  }
}
