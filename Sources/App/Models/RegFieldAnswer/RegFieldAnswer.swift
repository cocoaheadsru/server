import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation
final class RegFieldAnswer: Model {
    
  let storage = Storage()
  
  // sourcery: ignoreInJSON
  var regFieldId: Identifier
  var value: String
  
  init(value: String, regFieldId: Identifier) {
    self.value = value
    self.regFieldId = regFieldId
  }
  
  // sourcery:inline:auto:RegFieldAnswer.AutoModelGeneratable
  init(row: Row) throws {
    regFieldId = try row.get(Keys.regFieldId)
    value = try row.get(Keys.value)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.regFieldId, regFieldId)
    try row.set(Keys.value, value)
    return row
  }
  // sourcery:end
}

extension RegFieldAnswer {

  static func fieldAnswers(by fieldId: Identifier) throws -> JSON {
    return try RegFieldAnswer.makeQuery()
      .filter(RegFieldAnswer.Keys.regFieldId, fieldId)
      .all()
      .makeJSON()
  }
  
}
