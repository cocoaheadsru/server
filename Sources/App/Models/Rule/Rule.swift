import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Rule: Model {
    
  let storage = Storage()
  
  // sourcery: enum, email, number, alphanumeric, string, phone
  var type: ValidationRule
  
  init(type: ValidationRule) {
    self.type = type
  }


// sourcery:inline:auto:Rule.AutoModelGeneratable
  init(row: Row) throws {
    type = ValidationRule(try row.get(Keys.type))
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.type, type.string)
    return row
  }
// sourcery:end
}
