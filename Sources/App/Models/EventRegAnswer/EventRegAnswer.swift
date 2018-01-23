import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation
final class EventRegAnswer: Model {
    
  let storage = Storage()
  var eventRegId: Identifier
  var regFieldId: Identifier
  var regFieldAnswerId: Identifier
  var answerValue: String
  
  init(eventRegId: Identifier,
       regFieldId: Identifier,
       regFieldAnswerId: Identifier,
       answerValue: String) {
    self.eventRegId = eventRegId
    self.regFieldId = regFieldId
    self.regFieldAnswerId = regFieldAnswerId
    self.answerValue = answerValue
  }
  
  // sourcery:inline:auto:EventRegAnswer.AutoModelGeneratable
  init(row: Row) throws {
    eventRegId = try row.get(Keys.eventRegId)
    regFieldId = try row.get(Keys.regFieldId)
    regFieldAnswerId = try row.get(Keys.regFieldAnswerId)
    answerValue = try row.get(Keys.answerValue)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.eventRegId, eventRegId)
    try row.set(Keys.regFieldId, regFieldId)
    try row.set(Keys.regFieldAnswerId, regFieldAnswerId)
    try row.set(Keys.answerValue, answerValue)
    return row
  }
  // sourcery:end
}

extension EventRegAnswer {
  
  func eventRegistration() throws -> EventReg? {
    return try parent(id: eventRegId).get()
  }
  
  func answer() throws -> RegFieldAnswer? {
    return try children().first()
  }
  
}
