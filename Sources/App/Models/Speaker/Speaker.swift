import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Speaker: Model {
  
  static var entity: String = "speaker"
  
  let storage = Storage()
  
  // sourcery: relation = parent, relatedModel = User
  var userId: Identifier
  // sourcery: relation = parent, relatedModel = Event
  var eventId: Identifier
  
  init(userId: Identifier, eventId: Identifier) {
    self.userId = userId
    self.eventId = eventId
  }

  // sourcery:inline:auto:Speaker.AutoModelGeneratable

  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    eventId = try row.get(Keys.eventId)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.eventId, eventId)
    return row
  }
  // sourcery:end
}

extension Speaker {
  
  func user() throws -> User? {
    return try parent(id: userId).get()
  }
  
  func event() throws -> Event? {
    return try parent(id: eventId).get()
  }
}
