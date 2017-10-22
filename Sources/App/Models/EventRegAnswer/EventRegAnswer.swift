import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation
final class EventRegAnswer: Model {
  
  static var entity: String = "event_reg_answer"
  
  let storage = Storage()
  
  // sourcery: relatedModel = EventReg
  var regId: Identifier
  // sourcery: relatedModel = EventRegField
  var fieldId: Identifier
  // sourcery: relatedModel = RegFieldAnswer
  var answerId: Identifier
  var answerValue: String
  
  init(regId: Identifier, fieldId: Identifier, answerId: Identifier, answerValue: String) {
    self.regId = regId
    self.fieldId = fieldId
    self.answerId = answerId
    self.answerValue = answerValue
  }
  
  // sourcery:inline:auto:EventRegAnswer.AutoModelGeneratable
  init(row: Row) throws {
    regId = try row.get(Keys.regId)
    fieldId = try row.get(Keys.fieldId)
    answerId = try row.get(Keys.answerId)
    answerValue = try row.get(Keys.answerValue)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.regId, regId)
    try row.set(Keys.fieldId, fieldId)
    try row.set(Keys.answerId, answerId)
    try row.set(Keys.answerValue, answerValue)
    return row
  }
  // sourcery:end
}

extension EventRegAnswer {
  
  func eventRegistration() throws -> EventReg? {
    return try children().first()
  }
  
  func answer() throws -> RegFieldAnswer? {
    return try children().first()
  }
  
//  func eventRegAnswers() throws -> [EventRegAnswer] {
//    return ...
//  }
}


