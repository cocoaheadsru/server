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
    static let title = "title"
    static let description = "description"
    static let speakers = "speakers"
    static let contents = "contents"
  }
}

extension Speech: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(Event.self, optional: false, unique: false, foreignIdKey: Keys.eventId)
      builder.string(Keys.title)
      builder.string(Keys.description)
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
    try json.set(Keys.title, title)
    try json.set(Keys.description, description)
    try json.set(Keys.speakers, speakers().makeJSON())
    try json.set(Keys.contents, contents().makeJSON())
    return json
  }
}
