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
    let regFieldType = ["checkbox","radio","string"]
    let regFieldRules = ["phone","number","alphanumeric","email","string"]
    var regFieldRuleEntities: [Rule] = []
    var regFieldId: [Identifier] = []
    
    try regFieldRules.forEach{ rule in
      let regFieldRule = Rule(type: Rule.ValidationRule(rule))
      try regFieldRule.save()
      regFieldRuleEntities.append(regFieldRule)
    }
    
    for _ in iterations.min...iterations.max {
      let rule1 = regFieldRuleEntities[Int.randomValue(min: 0, max: 1)]
      let regField = RegField(
        name: String.randomValue,
        type: RegField.FieldType(regFieldType.randomValue),
        placeholder: String.randomValue)
      try regField.save()
      try regField.rules.add(rule1)
      if Bool.randomValue {
        let rule2 = regFieldRuleEntities[Int.randomValue(min: 2, max: 4)]
        try regField.rules.add(rule2)
      }
      regFieldId.append(regField.id!)
    }
    
    for _ in iterations.min...iterations.max {
      let eventRegField = EventRegField(
        regFormId: regFormId,
        fieldId: regFieldId.randomValue,
        shouldSave: Bool.randomValue,
        required: Bool.randomValue)
      try eventRegField.save()
    }
    return eventId
  }
  
  static func fetchRegFieldsByEventId(_ eventId: Identifier) throws  -> JSON? {
    guard let regForm = try RegFormHelper.fetchRegFormByEventId(eventId) else {
      return nil
    }
    
    let regFields = try EventRegField.makeQuery().filter(EventRegField.Keys.regFormId,regForm.id!).all()
    var regFieldsJSON = try regFields.makeJSON()
    regFieldsJSON.removeKey("id")
    regFieldsJSON.removeKey("reg_form_id")
    
    //var result = try regForm.makeJSON()
    //try result.set("reg_fields", regFieldsJSON)
    
    return regFieldsJSON
    
  }
}
