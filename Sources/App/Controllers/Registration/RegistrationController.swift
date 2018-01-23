import HTTP
import Vapor
import Fluent

final class  RegistrationController {
  
  let autoapprove = try? AutoapproveController()
  
  func store(_ req: Request) throws -> ResponseRepresentable {
    
    let userId = try getUserId(from: req)
    
    guard let regFormId = try req.json?.get(Keys.regFormId) as Identifier! else {
      throw Abort(.internalServerError, reason: "Can't get 'fields' and 'reg_form_Id' from request")
    }
  
    guard try EventReg.duplicationCheck(regFormId: regFormId, userId: userId) else {
      throw Abort(
        .internalServerError,
        reason: "User with token '\(req.headers.userToken ?? "no_token")' has alredy registered to this event")
    }
  
    guard
      let user = try User.find(userId),
      let event = try RegForm.find(regFormId)?.event,
      let grandApprove = try autoapprove?.grandApprove(to: user, on: event)
    else {
      throw Abort(.internalServerError, reason: "Can't check autoapprove status")
    }
    
    let eventReg = EventReg(
      regFormId: regFormId,
      userId: userId,
      status: grandApprove ? EventReg.RegistrationStatus.approved : EventReg.RegistrationStatus.waiting)
    try eventReg.save()

    try storeEventRegAnswers(req, eventReg: eventReg)
    
    return eventReg
  }

  func cancel(_ req: Request, eventReg: EventReg) throws -> ResponseRepresentable {
    
    let userId = try getUserId(from: req)
    
    guard
      eventReg.status == EventReg.RegistrationStatus.approved,
      eventReg.userId == userId
    else {
      throw Abort(.internalServerError, reason: "Can't find approved User's registraion for cancel")
    }
    
    try eventReg.delete()
    return try Response(
      status: .ok,
      message: "Registration is canceled"
    )
  }
  
}

extension RegistrationController: ResourceRepresentable {
  
  func makeResource() -> Resource<EventReg> {
    return Resource(
      store: store,
      destroy: cancel
    )
  }
}

extension RegistrationController: EmptyInitializable { }
