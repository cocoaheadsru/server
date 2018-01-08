import Vapor
import Fluent

@testable import App

final class EventRegFieldsHelper {
  
  static func store() throws -> App.Event? {
    
    guard
      let event = try RegFormHelper.store(),
      let eventId = event.id,
      let regForm = try RegFormHelper.fetchRegFormByEventId(eventId),
      let regFormId = regForm.id
      else {
        return nil
    }
    
    var regFieldId: [Identifier] = []
    
    guard let regFieldRuleEntities = Rule.rules else {
      return nil
    }
    
    let count = RegField.FieldType.count
    for i in 0...Int.randomValue(min: count, max: 10)  {
      let rule1 = regFieldRuleEntities[Int.randomValue(min: 0, max: 2)]
      //we use 'i % count' to use during a test all field types 
      let regField = try RegField(fieldTypeNumber: i % count, regFormId: regFormId)
      try regField.save()
      try regField.rules.add(rule1)
      if Bool.randomValue {
        let rule2 = regFieldRuleEntities[Int.randomValue(min: 3, max: 4)]
        try regField.rules.add(rule2)
      }
      regFieldId.append(regField.id!)
    }
    
    for regField in regFieldId {
      
      for _ in 1...Int.random(min: 2, max: 5) {
        let regFieldAnswer = RegFieldAnswer(
          value: String.randomValue,
          fieldId: regField)
        try regFieldAnswer.save()
      }
    }
    
    return event
  }
  
  typealias RegFields = JSON
  
  static func fetchRegFieldsByEventId(_ eventId: Identifier) throws  -> RegFields? {
    
    guard let regForm = try RegFormHelper.fetchRegFormByEventId(eventId) else {
      return nil
    }

    var result: JSON = [:]
    try result.set("id", regForm.id!)
    try result.set("form_name", regForm.formName)

    var regFields: [JSON] = []
    for regField in try RegField.makeQuery().filter(RegField.Keys.regFormId, regForm.id!).all() {
      var json: JSON = [:]
      try json.set("id", regField.id!)
      try json.set("required", regField.required)
      var fields: JSON = [:]
      try fields.set("name", regField.name)
      try fields.set("type", regField.type.string)
      try fields.set("placeholder", regField.placeholder)
      try fields.set("default_value", regField.defaultValue)
      var fieldAnswers = try RegFieldAnswer.makeQuery().filter("field_id", regField.id!).all().makeJSON()
      fieldAnswers.removeKey("field_id")
      
      try fields.set("field_answers", fieldAnswers)
      try json.set("field", fields)
      regFields.append(json)
    }
    try result.set("reg_fields", regFields)
    print("*** Expected Result ***")
    print(try result.serialize(prettyPrint: true).makeString())
    return result
  }
}
