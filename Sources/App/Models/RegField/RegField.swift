import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, fromJSON, Updateable
final class RegField: Model {
  
  static var entity: String = "reg_field"
  
  let storage = Storage()
  
  // sourcery: enum, string, radio, checkbox
  var type: FieldType
  // sourcery: relatedModel = RegFieldRule
  var rules: [Identifier]
  var name: String
  var placeholder: String
  
  init(name: String,
       type: FieldType,
       placeholder: String,
       rules: [Identifier]) {
    self.name = name
    self.type = type
    self.placeholder = placeholder
    self.rules = rules
  }

  // sourcery:inline:auto:RegField.AutoModelGeneratable

  init(row: Row) throws {
    type = FieldType(try row.get(Keys.type))
    rules = try row.get(Keys.rules)
    name = try row.get(Keys.name)
    placeholder = try row.get(Keys.placeholder)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.type, type.string)
    try row.set(Keys.rules, rules)
    try row.set(Keys.name, name)
    try row.set(Keys.placeholder, placeholder)
    return row
  }
  // sourcery:end
}

extension RegField {
  
  func eventRegFields() throws -> [EventRegField] {
    return try EventRegField.makeQuery().filter(EventRegField.Keys.fieldId, id).all()
  }
  
  func regFieldAnswers() throws -> [RegFieldAnswer] {
    return try RegFieldAnswer.makeQuery().filter(RegFieldAnswer.Keys.fieldId, id).all()
  }
  
  func validationRules() throws -> [RegFieldRule] {
    return try children().all()
  }
}
