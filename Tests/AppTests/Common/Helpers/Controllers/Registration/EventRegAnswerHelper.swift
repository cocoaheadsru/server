import Vapor
import Fluent
@testable import App

typealias SessionToken = String
typealias Body = JSON
typealias UserAnswer = (body: Body, sessionToken: SessionToken)

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
final class EventRegAnswerHelper {
  
  static func store() throws -> RegForm? {
    try! UserSessionHelper.store()
    guard
      let regForm = try! RegFormHelper.store()?.random,
      let regFields = try! RegFieldHelper.store(for: [regForm]),
      try! RegFieldAnswerHelper.store(for: regFields) != nil
    else {
      return nil
    }
    return regForm
  }
  
  static func generateUserAnswers(for regForm: RegForm) throws -> UserAnswer? {
    return try _generateUserAnswers(for: regForm)
  }
  
  @discardableResult
  static func generateUserAnswers(with token: SessionToken, for regForm: RegForm) throws -> UserAnswer? {
    return try _generateUserAnswers(token: token, for: regForm)
  }
  
  static func generateUserWrongRadioAnswers(for regForm: RegForm) throws -> UserAnswer? {
    return try _generateUserAnswers(correctRadio: false, for: regForm)
  }
  
  static func generateUserWrongRequiredAnswers(for regForm: RegForm) throws -> UserAnswer? {
    return try _generateUserAnswers(correctRequired: false, for: regForm)
  }
  
  private static func  _generateUserAnswers(
    correctRadio: Bool = true,
    correctRequired: Bool = true,
    token: SessionToken? = nil,
    for regForm: RegForm) throws -> UserAnswer? {
    
    func selectUser(_ token: SessionToken?) throws -> User {
      guard
        let token = token,
        let user = try Session.find(by: token)?.user
      else {
        return try User.all().randomValue
      }
      return user
    }
    
    let user = try selectUser(token)
    
    guard
      let sessionToken = token == nil ? try Session.makeQuery().filter(Session.Keys.userId, user.id!).first()?.token : token,
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
      
      if !correctRequired && regField.required {
        try field.set("user_answers", userAnswers)
        fields.append(field)
        continue
      }
      
      for regFieldAnswer in  regFieldAnswers {
        
        var userAnswer = JSON()
        try userAnswer.set("id", try regFieldAnswer.get("id") as Int)
        try userAnswer.set("value", String.randomValue)
        userAnswers.append(userAnswer)
        
        if correctRadio && regField.type == RegField.FieldType.radio {
          break
        }
        
      }
      
      try field.set("user_answers", userAnswers)
      fields.append(field)
    }
    try body.set("fields", fields)
    return UserAnswer(body, sessionToken)
  }
  
  // MARK: - get stored answer to compare with expected result
  
  static func getStoredAnswers(by sessionToken: SessionToken, regForm: RegForm) throws -> Body? {
    
    guard
      let userId = try Session.find(by: sessionToken)?.user?.id,
      let regFormId =  regForm.id,
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
