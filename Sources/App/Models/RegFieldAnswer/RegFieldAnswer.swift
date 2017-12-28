import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation
final class RegFieldAnswer: Model {
    
  let storage = Storage()
  
  // sourcery: relatedModel = RegField
  var fieldId: Identifier
  var value: String
  
  init(value: String, fieldId: Identifier) {
    self.value = value
    self.fieldId = fieldId
  }
  
  // sourcery:inline:auto:RegFieldAnswer.AutoModelGeneratable
  init(row: Row) throws {
    fieldId = try row.get(Keys.fieldId)
    value = try row.get(Keys.value)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.fieldId, fieldId)
    try row.set(Keys.value, value)
    return row
  }
  // sourcery:end
}

extension RegFieldAnswer {
  
  func field() throws -> RegField? {
    return try children().first()
  }
  
  static func fieldAnswers(by fieldId: Identifier) throws -> JSON {
    return try RegFieldAnswer.makeQuery()
      .filter(RegFieldAnswer.Keys.fieldId, fieldId)
      .all()
      .makeJSON()
  }
  
}
