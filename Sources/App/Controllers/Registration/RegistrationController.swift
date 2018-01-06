import HTTP
import Vapor

final class  RegistrationController {
  
  func index(_ req: Request) throws -> ResponseRepresentable {
    
    guard let eventId = req.parameters["id"]?.int else {
      return try Response(
        status: .badRequest,
        message: "ERROR: EventId parameters is missing in URL request"
      )
    }
    
    guard let regForm = try RegForm.getRegForm(by: eventId) else {
      return try Response(
        status: .ok,
        message: "ERROR: Can't find RegForm by event_id: \(eventId)"
      )
    }
    
    guard let regFields = try RegField.getEventRegFieldBy(regForm.id!), regFields.count > 0 else {
      return try Response(
        status: .ok,
        message: "ERROR: Can't find RegFields by event_id: \(eventId) and regform_id: \(regForm.id?.int ?? 0)"
      )
    }
    
    var result = try regForm.makeJSON()
    let regFieldsJSON = try regFields.map { try $0.fieldToJSON() }
    try result.set(RegField.AnswersKeys.regFields, regFieldsJSON)
    return result
  }
  
  func store(_ req: Request) throws -> ResponseRepresentable {
    
    guard let eventId = req.parameters["id"]?.int else {
      return try Response(
        status: .badRequest,
        message: "ERROR: EventId parameters is missing in URL request"
      )
    }
    
    guard let regFormId = try RegForm.getRegForm(by: eventId)?.id else {
      return try Response(
        status: .ok,
        message: "ERROR: Can't find RegForm by event_id: \(eventId)"
      )
    }
    
    guard let session = req.headers[Constants.Header.Key.userToken] else {
      return try Response(
        status: .badRequest,
        message: "ERROR: EventId parameters is missing in URL request"
      )
    }
    
    guard let userId = try Session.makeQuery().filter(Session.Keys.token, session).first()?.userId else {
      return try Response(
        status: .ok,
        message: "ERROR: Can't find User with session: \(session)"
      )
    }
    
    guard
      let contentType = req.headers[Constants.Header.Key.contentType],
      contentType.contains(Constants.Header.Value.applicationJson),
      let bytes = req.body.bytes else  {
        return try Response(
          status: .ok,
          message: "ERROR: Can't get JSON from Body"
        )
    }
    
    let json = try JSON(bytes: bytes)
//    print("**** Recived request ****")
//    print(try json.serialize(prettyPrint: true).makeString())
    
    guard
      let fields = json[Keys.fields]?.array,
      let regFormIdFromBody = json[Keys.regFormId]?.int
    else {
      return try Response(
        status: .ok,
        message: "ERROR: Can't convert Body to JSON"
      )
    }
    
    guard regFormId.int! == regFormIdFromBody else {
      return try Response(
        status: .ok,
        message: "ERROR: RegFormId recived by event_id '\(eventId)' don't matched with reg_form_id: \(regFormIdFromBody) from request's body"
      )
    }
    
    guard try EventReg.duplicationCheck(regFormId: regFormId, userId: userId) else {
      return try Response(
        status: .ok,
        message: "ERROR: User with session '\(session)' has alredy applied"
      )
    }
  
    let eventReg = EventReg(regFormId: regFormId, userId: userId)
    try eventReg.save()
    guard let eventRegId = eventReg.id else {
      return try Response(
        status: .ok,
        message: "ERROR: can't create eventRegId for regFormId: '\(regFormId.int!)' and userId: '\(userId.int!)"
      )
    }
    
    for field in fields {
      
      let fieldId = try field.get(EventRegAnswer.Keys.fieldId) as Identifier
      let userAnswers = try field.get(Keys.userAnswers) as [JSON]
      
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
      message: "OK: stored \(fields.count) fields"
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
