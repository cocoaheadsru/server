// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Speaker {
  static var entity: String = "speaker"
}

extension Speaker {

  struct Keys {
    static let id = "id"
    static let userId = "user_id"
    static let eventId = "event_id"
  }
}

extension Speaker: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(User.self, optional: false, unique: false, foreignIdKey: Keys.userId)
      builder.parent(Event.self, optional: false, unique: false, foreignIdKey: Keys.eventId)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Speaker: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.userId, userId)
    try json.set(Keys.eventId, eventId)
    return json
  }
}
