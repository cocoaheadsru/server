// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension EventRegAnswer {
  static var entity: String = "event_reg_answer"
}

extension EventRegAnswer {

  struct Keys {
    static let id = "id"
    static let eventRegId = "event_reg_id"
    static let regFieldId = "reg_field_id"
    static let regFieldAnswerId = "reg_field_answer_id"
    static let answerValue = "answer_value"
  }
}

extension EventRegAnswer: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      eventRegId: try json.get(Keys.eventRegId),
      regFieldId: try json.get(Keys.regFieldId),
      regFieldAnswerId: try json.get(Keys.regFieldAnswerId),
      answerValue: try json.get(Keys.answerValue)
    )
  }
}

extension EventRegAnswer: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: EventReg.self, optional: false, unique: false, foreignIdKey: Keys.eventRegId, foreignKeyName: self.entity + "_" + Keys.eventRegId)
      builder.foreignId(for: RegField.self, optional: false, unique: false, foreignIdKey: Keys.regFieldId, foreignKeyName: self.entity + "_" + Keys.regFieldId)
      builder.foreignId(for: RegFieldAnswer.self, optional: false, unique: false, foreignIdKey: Keys.regFieldAnswerId, foreignKeyName: self.entity + "_" + Keys.regFieldAnswerId)
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
    try json.set(Keys.eventRegId, eventRegId)
    try json.set(Keys.regFieldId, regFieldId)
    try json.set(Keys.regFieldAnswerId, regFieldAnswerId)
    try json.set(Keys.answerValue, answerValue)
    return json
  }
}
