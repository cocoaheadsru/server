import Vapor
import Fluent

@testable import App

final class RegFieldHelper {
  
  static func assertRegFieldHasExpectedFields(_ regFields: JSON) throws -> Bool {
    guard
      let _ = regFields["id"]?.int,
      let _ = regFields["name"]?.string,
      let _ = regFields["default_value"]?.string,
      let _ = regFields["required"]?.bool,
      let _ = regFields["type"]?.string,
      let _ = regFields["placeholder"]?.string,
      let _ = regFields["field_answers"]?.makeJSON()
      else {
        return false
    }
    return true
  }
  
  static func store(for regForms: [RegForm]) throws -> [RegField]? {
  
    var regFields: [RegField]! = []
    for regForm in regForms {
      guard let regFormId = regForm.id else {
        return nil
      }
      let count = RegField.FieldType.count
      for i in 0...Int.randomValue(min: count, max: 4) {
        // we use 'i % count' to cover during the test all field types
        let regField = try RegField(fieldTypeNumber: i % count, regFormId: regFormId)
        try regField.save()
        regFields.append(regField)
      }
    }
    return regFields
  }
  
}
