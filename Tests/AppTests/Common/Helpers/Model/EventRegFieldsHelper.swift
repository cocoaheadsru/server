import Vapor
import Fluent

@testable import App

final class EventRegFieldsHelper {
  
  /// get eventId
  static func store() throws -> Identifier? {
    
    guard let eventId = try RegFormHelper.store(),
      let regForm = try RegFormHelper.fetchRegFormByEventId(eventId),
      let regFormId = regForm.id
      else {
        return nil
    }
    
    let iterations: (min: Int, max: Int) = (min: 1, max: Int.random(min: 2, max: 10))
    let regFieldType = ["checkbox", "radio", "string"]
    let regFieldRules = ["phone", "number", "alphanumeric", "email", "string"]
    var regFieldRuleEntities: [Rule] = []
    var regFieldId: [Identifier] = []
    
    try regFieldRules.forEach { rule in
      let regFieldRule = Rule(type: Rule.ValidationRule(rule))
      try regFieldRule.save()
      regFieldRuleEntities.append(regFieldRule)
    }
    
    for _ in iterations.min...iterations.max {
      let rule1 = regFieldRuleEntities[Int.randomValue(min: 0, max: 2)]
      let regField = RegField(
        regFormId: regFormId,
        required: Bool.randomValue,
        name: String.randomValue,
        type: RegField.FieldType(regFieldType.randomValue),
        placeholder: String.randomValue,
        defaultValue: String.randomValue)
      try regField.save()
      try regField.rules.add(rule1)
      if Bool.randomValue {
        let rule2 = regFieldRuleEntities[Int.randomValue(min: 3, max: 4)]
        try regField.rules.add(rule2)
      }
      regFieldId.append(regField.id!)
    }
    
    for regField in regFieldId {
      
      let iterations: (min: Int, max: Int) = (min: 1, max: Int.random(min: 2, max: 5))
      for _ in iterations.min...iterations.max {
        let regFieldAnswer = RegFieldAnswer(
          value: String.randomValue,
          fieldId: regField)
        try regFieldAnswer.save()
      }
    }
    
    return eventId
  }
  
  static func fetchRegFieldsByEventId(_ eventId: Identifier) throws  -> JSON? {
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
