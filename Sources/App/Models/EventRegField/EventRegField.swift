import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class EventRegField: Model {
  
  static var entity: String = "event_reg_field"
  
  let storage = Storage()
  
  // sourcery: relation = parent, relatedModel = RegForm
  var regFormId: Identifier
  // sourcery: relatedModel = RegField
  var fieldId: Identifier
  var shouldSave: Bool
  var required: Bool
  
  init(regFormId: Identifier,
       fieldId: Identifier,
       shouldSave: Bool,
       required: Bool) {
    self.regFormId = regFormId
    self.fieldId = fieldId
    self.shouldSave = shouldSave
    self.required = required
  }
  
  // sourcery:inline:auto:EventRegField.AutoModelGeneratable

  init(row: Row) throws {
    regFormId = try row.get(Keys.regFormId)
    fieldId = try row.get(Keys.fieldId)
    shouldSave = try row.get(Keys.shouldSave)
    required = try row.get(Keys.required)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.regFormId, regFormId)
    try row.set(Keys.fieldId, fieldId)
    try row.set(Keys.shouldSave, shouldSave)
    try row.set(Keys.required, required)
    return row
  }
  // sourcery:end
}

extension EventRegField {
  
  func regForm() throws -> RegForm? {
    return try parent(id: regFormId).get()
  }
  
  func field() throws -> RegField? {
    return try children().first()
  }
}
