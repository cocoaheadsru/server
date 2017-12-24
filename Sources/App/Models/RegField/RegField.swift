import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, fromJSON, Updateable
final class RegField: Model {
    
  let storage = Storage()
  
  // sourcery: enum, string, radio, checkbox
  var type: FieldType
  var name: String
  var placeholder: String
  
  init(name: String,
       type: FieldType,
       placeholder: String) {
    self.name = name
    self.type = type
    self.placeholder = placeholder
  }

  // sourcery:inline:auto:RegField.AutoModelGeneratable
  init(row: Row) throws {
    type = FieldType(try row.get(Keys.type))
    name = try row.get(Keys.name)
    placeholder = try row.get(Keys.placeholder)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.type, type.string)
    try row.set(Keys.name, name)
    try row.set(Keys.placeholder, placeholder)
    return row
  }
  // sourcery:end
}

extension RegField {
  
  var rules: Siblings<RegField, Rule, Pivot<RegField, Rule>> {
    return siblings()
  }
  
  func eventRegFields() throws -> [EventRegField] {
    return try EventRegField.makeQuery().filter(EventRegField.Keys.fieldId, id).all()
  }
  
  func regFieldAnswers() throws -> [RegFieldAnswer] {
    return try RegFieldAnswer.makeQuery().filter(RegFieldAnswer.Keys.fieldId, id).all()
  }
  
}


