import Vapor
import Fluent
@testable import App

typealias SessionToken = String
typealias Body = JSON
typealias UserAnswer = (body: Body, sessionToken: SessionToken)

final class EventRegAnswerHelper {
  
  static func store() throws -> App.Event? {
    return try EventRegHelper.store()
  }
  
  static func  getUserAnswers(for event: App.Event) throws -> UserAnswer? {
    
    let user = try User.all().randomValue
    guard
      let sessionToken = try Session.makeQuery().filter("user_id", user.id!).first()?.token,
      let regForm = try event.registrationForm(),
      let regFormId = regForm.id?.int
    else {
      return nil
    }
    let regFields = try regForm.eventRegFields()
    
    var body = JSON()
    var fields = [JSON]()
    try body.set("reg_form_id", regFormId)
    
    for regField in regFields {
      guard let fieldId = regField.id?.int else {
        return nil
      }
      var field = JSON()
      try field.set("field_id", fieldId)
      
      guard let regFieldAnswers = try RegFieldAnswer.fieldAnswers(by: regField.id!).array else {
        return nil
      }
      
      var userAnswers = [JSON]()
      
      for regFieldAnswer in  regFieldAnswers {
        var userAnswer = JSON()
        try userAnswer.set("id", try regFieldAnswer.get("id") as Int)
        try userAnswer.set("value", String.randomValue)
        userAnswers.append(userAnswer)
      }
      
      try field.set("user_answers", userAnswers)
      fields.append(field)
    }
    try body.set("fields", fields)
    
    print("*** CLIENT RESPONSE ***")
    print(try body.serialize(prettyPrint: true).makeString())
    print("User sessionToken: \(sessionToken)")
    return UserAnswer(body, sessionToken)
  }
  
  static func getStoredAnswers(by sessionToken: SessionToken, eventId: Identifier) throws -> Body? {
    
    guard
      let userId = try Session.makeQuery().filter(Session.Keys.token,sessionToken).first()?.userId,
      let regFormId =  try RegForm.getRegFormBy(eventId.int!)?.id!,
      let regId = try EventReg
        .makeQuery()
        .filter("reg_form_id",regFormId)
        .filter("user_id",userId)
        .first()?.id
    else {
      return nil
    }
    let answers = try EventRegAnswer.makeQuery().filter(EventRegAnswer.Keys.regId,regId).all()
    
    var body = JSON()
    var fields = [JSON]()
    try body.set("reg_form_id", regFormId.int!)
    
    for answer in answers {
      guard let fieldId = answer.fieldId.int else {
        return nil
      }
      var field = JSON()
      try field.set("field_id", fieldId)
      
      guard let fieldAnswers = try EventRegAnswer.makeQuery()
        .filter(EventRegAnswer.Keys.regId,regId)
        .filter(EventRegAnswer.Keys.fieldId,answer.fieldId)
        .all()
        .makeJSON()
        .array
      else {
        return nil
      }
      
      var userAnswers = [JSON]()
      
      for fieldAnswer in fieldAnswers {
        var userAnswer = JSON()
        try userAnswer.set("id", try fieldAnswer.get("answer_id") as Int)
        try userAnswer.set("value", try fieldAnswer.get("answer_value") as String)
        userAnswers.append(userAnswer)
      }
      
      try field.set("user_answers", userAnswers)
      fields.append(field)
      
    }
    
    try body.set("fields", fields)
    return body
  }
  
}
