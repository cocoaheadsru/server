import Vapor
import Fluent
@testable import App
//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class RegFieldAnswerHelper {
  
  static func assertRegFieldAnswerHasExpectedFields(_ regFieldAnswer: JSON) throws -> Bool {
    guard
      let _ = regFieldAnswer["id"]?.int,
      let _ = regFieldAnswer["value"]?.string
      else {
        return false
    }
    return true
  }
  
  @discardableResult
  static func store(for regFields: [RegField]) throws -> [RegFieldAnswer]? {
    
    var regFieldAnswers = [RegFieldAnswer]()
    
    for regField in regFields {
      
      guard let regField = regField.id else {
        return nil
      }
      
      for _ in 1...Int.random(min: 2, max: 5) {
        let regFieldAnswer = RegFieldAnswer(
          value: String.randomValue,
          regFieldId: regField)
        try! regFieldAnswer.save()
        regFieldAnswers.append(regFieldAnswer)
      }
    
    }

    return regFieldAnswers
  }

}
