import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, fromJSON, Updateable
final class RegField: Model {
    
  let storage = Storage()
  
  // sourcery: relation = parent, relatedModel = RegForm
  var regFormId: Identifier
  var required: Bool
  // sourcery: enum,string,radio,checkbox
  var type: FieldType
  var name: String
  var placeholder: String
  var defaultValue: String
  
  init(regFormId: Identifier,
       required: Bool,
       name: String,
       type: FieldType,
       placeholder: String,
       defaultValue: String) {
    self.regFormId = regFormId
    self.required = required
    self.type = type
    self.name = name
    self.placeholder = placeholder
    self.defaultValue = defaultValue
  }

// sourcery:inline:auto:RegField.AutoModelGeneratable
  init(row: Row) throws {
    regFormId = try row.get(Keys.regFormId)
    required = try row.get(Keys.required)
    type = FieldType(try row.get(Keys.type))
    name = try row.get(Keys.name)
    placeholder = try row.get(Keys.placeholder)
    defaultValue = try row.get(Keys.defaultValue)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.regFormId, regFormId)
    try row.set(Keys.required, required)
    try row.set(Keys.type, type.string)
    try row.set(Keys.name, name)
    try row.set(Keys.placeholder, placeholder)
    try row.set(Keys.defaultValue, defaultValue)
    return row
  }
// sourcery:end
}

extension RegField {
  
  var rules: Siblings<RegField, Rule, Pivot<RegField, Rule>> {
    return siblings()
  }
  
  static func getEventRegField(by regFormId: Identifier) throws -> [RegField]? {
    return try RegField.makeQuery().filter(RegField.Keys.regFormId, regFormId).all()
  }
  
  func regForm() throws -> RegForm? {
    return try parent(id: regFormId).get()
  }
  
  func field() throws -> RegField? {
    return try children().first()
  }
  
  func fieldToJSON() throws -> JSON {
    
    func getNameAndTypeAndPlaceholderAndDefaultValueAndFieldAnswersJSON() throws -> JSON {
      var json = JSON()
      try json.set(Keys.name, name)
      try json.set(Keys.type, type.string)
      try json.set(Keys.placeholder, placeholder)
      try json.set(Keys.defaultValue, defaultValue)
      
      var fieldAnswers = try RegFieldAnswer.fieldAnswers(by: id!)
      fieldAnswers.removeKey(RegFieldAnswer.Keys.fieldId)
      
      try json.set(AnswersKeys.fieldAnswers, fieldAnswers)
      return json
    }
    
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.required, required)
    try json.set(AnswersKeys.field, getNameAndTypeAndPlaceholderAndDefaultValueAndFieldAnswersJSON())
    return json
  }
}

extension RegField {
  
  struct AnswersKeys {
    static let regFields = "reg_fields"
    static let field = "field"
    static let fieldAnswers = "field_answers"
  }
}
