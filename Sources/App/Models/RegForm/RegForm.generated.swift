// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension RegForm {

  struct Keys {
    static let id = "id"
    static let eventId = "event_id"
    static let formName = "form_name"
    static let description = "description"
  }
}

extension RegForm: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(Event.self, optional: false, unique: false, foreignIdKey: Keys.eventId)
      builder.string(Keys.formName)
      builder.string(Keys.description)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension RegForm: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.eventId, eventId)
    try json.set(Keys.formName, formName)
    try json.set(Keys.description, description)
    return json
  }
}
