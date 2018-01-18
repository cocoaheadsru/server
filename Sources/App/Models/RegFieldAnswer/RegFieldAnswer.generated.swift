// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension RegFieldAnswer {
  static var entity: String = "reg_field_answer"
}

extension RegFieldAnswer {

  struct Keys {
    static let id = "id"
    static let regFieldId = "reg_field_id"
    static let value = "value"
  }
}

extension RegFieldAnswer: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      value: try json.get(Keys.value),
      regFieldId: try json.get(Keys.regFieldId)
    )
  }
}

extension RegFieldAnswer: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(RegField.self, optional: false, unique: false, foreignIdKey: Keys.regFieldId)
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
    try json.set(Keys.value, value)
    return json
  }
}
