import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Speech: Model {
    
  let storage = Storage()
  
  // sourcery: relation = parent, relatedModel = Event, ignoreInJSON
  var eventId: Identifier
  var title: String?
  var description: String
  var photoUrl: String?
  
  init(eventId: Identifier,
       title: String?,
       description: String,
       photoUrl: String?) {
    self.eventId = eventId
    self.title = title
    self.description = description
    self.photoUrl = photoUrl
  }
  
  // sourcery:inline:auto:Speech.AutoModelGeneratable
  init(row: Row) throws {
    eventId = try row.get(Keys.eventId)
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
    photoUrl = try row.get(Keys.photoUrl)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.eventId, eventId)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    try row.set(Keys.photoUrl, photoUrl)
    return row
  }
  // sourcery:end
}

extension Speech {
  
  func event() throws -> Event? {
    return try parent(id: eventId).get()
  }
  
  func speakers() throws -> [Speaker] {
    return try children().all()
  }
  
  func contents() throws -> [Content] {
    return try children().all()
  }
}

