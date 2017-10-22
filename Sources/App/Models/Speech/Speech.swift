import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Speech: Model {
  
  static var entity: String = "speech"
  
  let storage = Storage()
  
  // sourcery: relatedModel = Event
  var eventId: Identifier
  // sourcery: relatedModel = Speaker
  var speakerId: Identifier
  var title: String
  var description: String
  var photoUrl: String
  
  init(eventId: Identifier, title: String, description: String, speakerId: Identifier, photoUrl: String) {
    self.eventId = eventId
    self.title = title
    self.description = description
    self.speakerId = speakerId
    self.photoUrl = photoUrl
  }
  
  // sourcery:inline:auto:Speech.AutoModelGeneratable
  init(row: Row) throws {
    eventId = try row.get(Keys.eventId)
    speakerId = try row.get(Keys.speakerId)
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
    photoUrl = try row.get(Keys.photoUrl)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.eventId, eventId)
    try row.set(Keys.speakerId, speakerId)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    try row.set(Keys.photoUrl, photoUrl)
    return row
  }
  // sourcery:end
}

extension Speech {
  
  func event() throws -> Event? {
    return try children().first()
  }
  
  func speaker() throws -> Speaker? {
    return try children().first()
  }
  
  func contents() throws -> [Content] {
    return try Content.makeQuery().filter(Content.Keys.speechId, id).all()
  }
}

