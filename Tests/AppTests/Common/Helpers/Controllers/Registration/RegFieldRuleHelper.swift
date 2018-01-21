import Vapor
import Fluent

@testable import App

final class RegFieldRuleHelper {
  
  static func assertRegFieldRuleHasExpectedFields(_ rules: JSON) throws -> Bool {
    guard
      let _ = rules["id"]?.int,
      let _ = rules["type"]?.string
      else {
        return false
    }
    return true
  }
  
  static func addRules(to regFields: [RegField]) throws -> [RegField]? {
  
    guard let rules = Rule.rules else {
      return nil
    }
    
    var result: [RegField]! = []
    for regField in regFields {
      let rule1 = rules[Int.randomValue(min: 0, max: 2)]
      try regField.rules.add(rule1)
      if Bool.randomValue {
        let rule2 = rules[Int.randomValue(min: 3, max: 4)]
        try regField.rules.add(rule2)
      }
      result.append(regField)
    }
    
    return result
  }
  
}
