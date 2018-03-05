import HTTP
import Vapor
import Fluent

final class  RegistrationController {
  
  let autoapprove = try? AutoapproveController()
  let drop: Droplet

  init(drop: Droplet) {
    self.drop = drop
  }

  func store(_ request: Request) throws -> ResponseRepresentable {

    let user = try request.user()
    guard let userId = user.id else {
      throw Abort(.internalServerError, reason: "Can't get user.id")
    }
    
    guard
      let json = request.json,
      let regFormIdInt  = json[Keys.regFormId]?.int
    else {
      throw Abort(.internalServerError, reason: "Can't get 'reg_form_Id' from request")
    }

    let regFormId = Identifier(.int(regFormIdInt))

    guard try EventReg.duplicationCheck(regFormId: regFormId, userId: userId) else {
      throw Abort(
        .internalServerError,
        reason: "User with token '\(user.token ?? "")' has alredy registered to this event")
    }
  
    guard
      let event = try RegForm.find(regFormId)?.event,
      let grandApprove = try autoapprove?.grandApprove(to: user, on: event)
    else {
      throw Abort(.internalServerError, reason: "Can't check autoapprove status")
    }

    let eventReg = EventReg(
      regFormId: regFormId,
      userId: userId,
      status: grandApprove ? EventReg.RegistrationStatus.approved : EventReg.RegistrationStatus.waiting)

    try drop.mysql().transaction { (connection)  in
      try eventReg.makeQuery(connection).save()
      try storeEventRegAnswers(request, eventReg: eventReg, connection: connection)
    }

    return eventReg
  }

  func cancel(_ request: Request, eventReg: EventReg) throws -> ResponseRepresentable {
    
    let user = try request.user()

    guard
      let userId = user.id,
      eventReg.status == EventReg.RegistrationStatus.approved,
      eventReg.userId == userId
    else {
      throw Abort(.internalServerError, reason: "Can't find approved User's registraion for cancel")
    }
    
    try eventReg.delete()
    return try Response( .ok, message: "Registration is canceled")
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
