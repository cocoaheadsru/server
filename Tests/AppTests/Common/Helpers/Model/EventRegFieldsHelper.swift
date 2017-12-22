import Vapor
@testable import App

final class EventRegFieldsHelper {
  
  static func clean() throws {
    try EventRegField.makeQuery().delete()
    try RegField.makeQuery().delete()
    try RegFieldRule.makeQuery().delete()
    try RegFormHelper.clean()
  }
  
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
    var regFieldRuleId: [Identifier] = []
    var regFieldId: [Identifier] = []
    
    try regFieldRules.forEach{ rule in
      let regFieldRule = RegFieldRule(type: RegFieldRule.ValidationRule(rule))
      try regFieldRule.save()
      regFieldRuleId.append(regFieldRule.id!)
    }
    
    for _ in iterations.min...iterations.max {
      let regField = RegField(
        name: String.randomValue,
        type: RegField.FieldType(regFieldType.randomValue),
        placeholder: String.randomValue,
        rules: [regFieldRuleId[Int.randomValue(min: 0, max: 1)],regFieldRuleId[Int.randomValue(min: 2, max: 4)]])
      try regField.save()
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
    var json = try regForm.makeJSON()
    try json.set("reg_fields", regFields.makeJSON())
    
    return json 
    
  }
}
