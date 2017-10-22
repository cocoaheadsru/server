// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension EventRegField {

  struct Keys {
    static let id = "id"
    static let regFormId = "reg_form_id"
    static let fieldId = "field_id"
    static let shouldSave = "should_save"
    static let required = "required"
  }
}

extension EventRegField: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(RegForm.self, optional: false, unique: false, foreignIdKey: Keys.regFormId)
      builder.foreignKey(Keys.fieldId, references: RegField.Keys.id, on: RegField.self)
      builder.bool(Keys.shouldSave)
      builder.bool(Keys.required)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension EventRegField: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.regFormId, regFormId)
    try json.set(Keys.fieldId, fieldId)
    try json.set(Keys.shouldSave, shouldSave)
    try json.set(Keys.required, required)
    return json
  }
}
