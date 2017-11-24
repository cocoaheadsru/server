import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, Updateable
final class EventReg: Model {
  
  static var entity: String = "event_reg"
  
  let storage = Storage()
  
  // sourcery: relatedModel = RegForm
  var regFormId: Identifier
  // sourcery: relation = parent, relatedModel = User
  var userId: Identifier
  // sourcery: enum, waiting, rejected, approved, canceled
  var status: RegistrationStatus = .waiting
  
  init(regFormId: Identifier, userId: Identifier, status: RegistrationStatus = .waiting) {
    self.regFormId = regFormId
    self.userId = userId
    self.status = status
  }
  
  // sourcery:inline:auto:EventReg.AutoModelGeneratable

  init(row: Row) throws {
    regFormId = try row.get(Keys.regFormId)
    userId = try row.get(Keys.userId)
    status = RegistrationStatus(try row.get(Keys.status))
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.regFormId, regFormId)
    try row.set(Keys.userId, userId)
    try row.set(Keys.status, status.string)
    return row
  }
  // sourcery:end
}

extension EventReg {
  
  func regForm() throws -> RegForm? {
    return try children().first()
  }
  
  func eventRegAnswers() throws -> [EventRegAnswer] {
    return try EventRegAnswer.makeQuery().filter(EventRegAnswer.Keys.regId, id).all()
  }
}


