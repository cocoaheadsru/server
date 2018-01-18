import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, ResponseRepresentable
final class RegForm: Model {
    
  let storage = Storage()
  
  // sourcery: relation = parent, relatedModel = Event, ignoreInJSON
  var eventId: Identifier
  var formName: String
  var description: String
  
  init(eventId: Identifier,
       formName: String,
       description: String) {
    self.eventId = eventId
    self.formName = formName
    self.description = description
  }
  
  // sourcery:inline:auto:RegForm.AutoModelGeneratable
  init(row: Row) throws {
    eventId = try row.get(Keys.eventId)
    formName = try row.get(Keys.formName)
    description = try row.get(Keys.description)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.eventId, eventId)
    try row.set(Keys.formName, formName)
    try row.set(Keys.description, description)
    return row
  }
  // sourcery:end
}

extension RegForm {
  // TODO: - change to nestedJSONRepresentableField
  // sourcery: nestedJSONField
  func regFields() throws -> [RegField] {
    return try children().all()
  }
  
  func eventRegFields() throws -> [RegField] {
    return try RegField.makeQuery().filter(RegField.Keys.regFormId, id).all()
  }
  
  var event: Event? {
    return try? parent(id: eventId).get()!
  }
  
  static func getRegForm(by eventId: Int) throws -> RegForm? {
    return try RegForm.makeQuery().filter(Keys.eventId, eventId).first()
  }
  
}
