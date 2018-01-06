import Vapor
import Fluent
@testable import App

typealias SessionToken = String
typealias Body = JSON
typealias UserAnswer = (body: Body, sessionToken: SessionToken)

final class EventRegAnswerHelper {
  
  static func store() throws -> App.Event? {
    try UserSessionHelper.store()
    return try EventRegFieldsHelper.store()
  }
  
  static func  getUserAnswers(for event: App.Event) throws -> UserAnswer? {
    
    let user = try User.all().randomValue
    guard
      let sessionToken = try Session.makeQuery().filter(Session.Keys.userId, user.id!).first()?.token,
      let regForm = try event.registrationForm(),
      let regFormId = regForm.id?.int
    else {
      return nil
    }
    let regFields = try regForm.eventRegFields()
    
    var body = JSON()
    var fields = [JSON]()
    try body.set(EventReg.Keys.regFormId, regFormId)
    
    for regField in regFields {
      guard let fieldId = regField.id?.int else {
        return nil
      }
      var field = JSON()
      try field.set(EventRegAnswer.Keys.fieldId, fieldId)
      
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
    return UserAnswer(body, sessionToken)
  }
  
  // MARK: - get stored answer to compare with expected result
  
  static func getStoredAnswers(by sessionToken: SessionToken, eventId: Identifier) throws -> Body? {
    
    guard
      let userId = try Session.makeQuery().filter(Session.Keys.token, sessionToken).first()?.userId,
      let regFormId =  try RegForm.getRegForm(by: eventId.int!)?.id!,
      let regId = try EventReg
        .makeQuery()
        .filter(EventReg.Keys.regFormId, regFormId)
        .filter(EventReg.Keys.userId, userId)
        .first()?.id
    else {
      return nil
    }
    
    let result = try EventRegAnswer.database?.raw(
      """
        SELECT e.field_id
        FROM event_reg_answer e
        WHERE reg_id = ?
        GROUP BY e.field_id
      """,
      [regId]
    )
    
    guard let fieldIds = result?.array else {
      return nil
    }
    
    var body = JSON()
    try body.set(EventReg.Keys.regFormId, regFormId.int!)
    var fields = [JSON]()
    
    for fieldId in fieldIds {
      guard let fieldId = try fieldId.get(EventRegAnswer.Keys.fieldId) as Int? else {
        return nil
      }
      var field = JSON()
      try field.set(EventRegAnswer.Keys.fieldId, fieldId)
      guard let fieldAnswers = try EventRegAnswer.makeQuery()
        .filter(EventRegAnswer.Keys.regId, regId)
        .filter(EventRegAnswer.Keys.fieldId, fieldId)
        .all()
        .makeJSON()
        .array
      else {
        return nil
      }

      var userAnswers = [JSON]()
      for fieldAnswer in fieldAnswers {
        var userAnswer = JSON()
        try userAnswer.set("id", try fieldAnswer.get(EventRegAnswer.Keys.answerId) as Int)
        try userAnswer.set("value", try fieldAnswer.get(EventRegAnswer.Keys.answerValue) as String)
        userAnswers.append(userAnswer)
      }

      try field.set("user_answers", userAnswers)
      fields.append(field)
      
    }
    
    try body.set("fields", fields)
    return body
  }
  
}
