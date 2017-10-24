// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension EventRegAnswer {

  struct Keys {
    static let id = "id"
    static let regId = "reg_id"
    static let fieldId = "field_id"
    static let answerId = "answer_id"
    static let answerValue = "answer_value"
  }
}

extension EventRegAnswer: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      regId: try json.get(Keys.regId),
      fieldId: try json.get(Keys.fieldId),
      answerId: try json.get(Keys.answerId),
      answerValue: try json.get(Keys.answerValue)
    )
  }
}

extension EventRegAnswer: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(EventReg.self, optional: false, unique: false, foreignIdKey: Keys.regId)
      builder.foreignKey(Keys.fieldId, references: EventRegField.Keys.id, on: EventRegField.self)
      builder.foreignKey(Keys.answerId, references: RegFieldAnswer.Keys.id, on: RegFieldAnswer.self)
      builder.string(Keys.answerValue)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension EventRegAnswer: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.regId, regId)
    try json.set(Keys.fieldId, fieldId)
    try json.set(Keys.answerId, answerId)
    try json.set(Keys.answerValue, answerValue)
    return json
  }
}