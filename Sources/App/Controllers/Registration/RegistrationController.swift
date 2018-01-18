import HTTP
import Vapor
import Fluent

final class  RegistrationController {
  
  func index(_ req: Request) throws -> ResponseRepresentable {
    
    guard let eventId = req.parameters["id"]?.int else {
      throw Abort(.badRequest, reason: "EventId parameters is missing in URL request")
    }
    
    guard let regForm = try RegForm.getRegForm(by: eventId) else {
      throw Abort(.internalServerError, reason: "Can't find RegForm by event_id: \(eventId)")
    }
  
    return regForm
  }
  
  func store(_ req: Request) throws -> ResponseRepresentable {
    
    guard
      let token = req.headers.userToken,
      let session = try Session.find(by: token),
      let userId = session.user?.id
    else {
      throw Abort(.internalServerError, reason: "Can't find User and get user id by token")
    }
    
    guard
      let fields = req.json?[Keys.fields]?.array,
      let regFormId = try req.json?.get(Keys.regFormId) as Identifier!
    else {
      throw Abort(.internalServerError, reason: "Can't get 'fields' and 'reg_form_Id' from request")
    }
  
    guard try EventReg.duplicationCheck(regFormId: regFormId, userId: userId) else {
      throw Abort(.internalServerError, reason: "User with token '\(token)' has alredy registered to this event")
    }
  
    let autoapprove = try AutoapproveController()
    guard
      let user = try User.find(userId),
      let event = try RegForm.find(regFormId)?.event,
      let grandApprove = try autoapprove.grandApprove(to: user, on: event)
    else {
      throw Abort(.internalServerError, reason: "Can't check autoapprove status")
    }
    
    let eventReg = EventReg(
      regFormId: regFormId,
      userId: userId,
      status: grandApprove ? EventReg.RegistrationStatus.approved : EventReg.RegistrationStatus.waiting)
    try eventReg.save()
    
    guard let eventRegId = eventReg.id else {
      throw Abort(.internalServerError, reason: "Can't create eventRegId")
    }
    
    for field in fields {
      
      let fieldId = try field.get(EventRegAnswer.Keys.fieldId) as Identifier
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
          regId: eventRegId,
          fieldId: fieldId,
          answerId: answerId,
          answerValue: answerValue
        )
        try eventRegAnswer.save()
      }
    }
    
    return try Response(
      status: .ok,
      message: "OK: stored \(fields.count) fields for user_id '\(userId.int ?? -1)'"
    )
    
  }

}

extension RegistrationController: ResourceRepresentable {
  
  func makeResource() -> Resource<RegForm> {
    return Resource(
      index: index,
      store: store
    )
  }
}

extension RegistrationController: EmptyInitializable { }
