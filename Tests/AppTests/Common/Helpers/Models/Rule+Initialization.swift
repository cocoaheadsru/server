import Vapor
@testable import App

extension Rule {
  
   static var rules: [Rule]? {
//swiftlint:disable force_try
    if try! Rule.count() < 1 {
//swiftlint:enable force_try
      var result: [Rule]? = []
      try? ["phone", "number", "alphanumeric", "email", "string"].forEach {
        let rule = Rule(type: Rule.ValidationRule($0))
        try rule.save()
        result?.append(rule)
      }
      return result
    }
    
    return try? Rule.all()
  }
}
