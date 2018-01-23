import Vapor
import Fluent
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
final class RegFieldHelper {
  
  static func assertRegFieldHasExpectedFields(_ regFields: JSON) throws -> Bool {
    return
      regFields["id"]?.int != nil &&
      regFields["name"]?.string != nil &&
      regFields["default_value"]?.string != nil &&
      regFields["required"]?.bool != nil &&
      regFields["type"]?.string != nil &&
      regFields["placeholder"]?.string != nil &&
      regFields["field_answers"]?.makeJSON() != nil

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
        let regField = RegField(fieldTypeNumber: i % count, regFormId: regFormId)
        try! regField.save()
        regFields.append(regField)
      }
    }
    return regFields
  }
  
}
