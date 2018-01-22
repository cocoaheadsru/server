import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, Updateable, ResponseRepresentable
final class EventReg: Model {
    
  let storage = Storage()
  
  var regFormId: Identifier
  var userId: Identifier
  // sourcery: enum, waiting, rejected, approved, canceled, notAppeared
  var status: RegistrationStatus = .waiting
  
  init(regFormId: Identifier,
       userId: Identifier,
       status: RegistrationStatus = .waiting) {
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
    return try children().all()
  }
  
  static func duplicationCheck(regFormId: Identifier, userId: Identifier) throws -> Bool {
   return try EventReg.makeQuery()
      .filter(EventReg.Keys.regFormId, regFormId)
      .filter(EventReg.Keys.userId, userId)
      .filter(EventReg.Keys.status, in: [
        EventReg.RegistrationStatus.waiting.string,
        EventReg.RegistrationStatus.approved.string])
      .all().count == 0
  }
  
  func willDelete() throws {
    try  eventRegAnswers()
      .forEach { try  $0.delete() }
  }
  
}
