import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class RegField: Model {
  
  let storage = Storage()
  
  var name: String
  // sourcery: enum, string, radio, checkbox
  var type: FieldType
  
  init(name: String, type: FieldType) {
    self.name = name
    self.type = type
  }

  // sourcery:inline:auto:RegField.AutoModelGeneratable
  init(row: Row) throws {
    name = try row.get(Keys.name)
    type = FieldType(try row.get(Keys.type))
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.name, name)
    try row.set(Keys.type, type.string)
    return row
  }
  // sourcery:end
}
