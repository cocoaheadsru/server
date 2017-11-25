// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension RegFieldAnswer {

  struct Keys {
    static let id = "id"
    static let fieldId = "field_id"
    static let value = "value"
  }
}

extension RegFieldAnswer: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      value: try json.get(Keys.value),
      fieldId: try json.get(Keys.fieldId)
    )
  }
}

extension RegFieldAnswer: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: RegField.self, optional: false, unique: false, foreignIdKey: Keys.fieldId)
      builder.string(Keys.value)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension RegFieldAnswer: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.fieldId, fieldId)
    try json.set(Keys.value, value)
    return json
  }
}
