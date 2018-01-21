import Vapor
import Fluent

extension RegistrationController {
  struct Keys {
    static let regFields = "reg_fields"
    static let regFormId = "reg_form_id"
    static let fields = "fields"
    static let userAnswers = "user_answers"
  }
  
  func checkRadio(fieldId: Identifier, answerCount: Int) throws -> Bool {
    let fiedlType = try RegField.find(fieldId)?.type
    if  fiedlType == RegField.FieldType.radio {
      return answerCount <= 1
    } else {
      return true
    }
  }
  
  func checkRequired(fieldId: Identifier, answerCount: Int) throws -> Bool {
    guard let fiedlRequired = try RegField.find(fieldId)?.required else {
      throw Abort.serverError
    }
    
    if fiedlRequired {
      return answerCount > 0
    } else {
      return true
    }
  }
  
  func storeEventRegAnswers(_ req: Request, eventReg: EventReg) throws {
   
    guard let eventRegId = eventReg.id else {
      throw Abort(.internalServerError, reason: "Can't get eventRegId")
    }
    
    guard let fields = req.json?[Keys.fields]?.array else {
        throw Abort(.internalServerError, reason: "Can't get 'fields' and 'reg_form_Id' from request")
    }
    
    for field in fields {
      
      let fieldId = try field.get(EventRegAnswer.Keys.regFieldId) as Identifier
      let userAnswers = try field.get(Keys.userAnswers) as [JSON]
      
      guard try checkRequired(fieldId: fieldId, answerCount: userAnswers.count) else {
        throw Abort(.internalServerError, reason: "The field must have at least one answer. Field id is '\(fieldId.int!)'")
      }
      
      guard try checkRadio(fieldId: fieldId, answerCount: userAnswers.count) else {
        throw Abort(.internalServerError, reason: "The answer to field with type radio should be only one. Field id is '\(fieldId.int!)'")
      }
      
      for userAnswer in userAnswers {
        let answerId = try userAnswer.get("id") as Identifier
        let answerValue = try userAnswer.get("value") as String
        
        let eventRegAnswer = EventRegAnswer(
          eventRegId: eventRegId,
          regFieldId: fieldId,
          regFieldAnswerId: answerId,
          answerValue: answerValue)
        
        try eventRegAnswer.save()
      }
    }
  }
  
}
