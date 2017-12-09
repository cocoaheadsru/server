// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider


extension Speech {
  static var entity: String = "speech"
}
extension Speech {

  struct Keys {
    static let id = "id"
    static let eventId = "event_id"
    static let speakerId = "speaker_id"
    static let title = "title"
    static let description = "description"
    static let photoUrl = "photo_url"
  }
}

extension Speech: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(Event.self, optional: false, unique: false, foreignIdKey: Keys.eventId)
      builder.foreignId(for: Speaker.self, optional: false, unique: false, foreignIdKey: Keys.speakerId)
      builder.string(Keys.title)
      builder.string(Keys.description)
      builder.string(Keys.photoUrl)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Speech: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.eventId, eventId)
    try json.set(Keys.speakerId, speakerId)
    try json.set(Keys.title, title)
    try json.set(Keys.description, description)
    try json.set(Keys.photoUrl, photoUrl)
    return json
  }
}
