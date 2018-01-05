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
    
    guard let regForm = try RegForm.getRegFormBy(eventId) else {
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
}

func store(_ req: Request) throws -> ResponseRepresentable {
  guard let eventId = req.parameters["id"]?.int else {
    return try Response(
      status: .badRequest,
      message: "ERROR: EventId parameters is missing in URL request"
    )
  }
  guard let regForm = try RegForm.getRegFormBy(eventId) else {
    return try Response(
      status: .ok,
      message: "ERROR: Can't find RegForm by event_id: \(eventId)"
    )
  }
  
 // ERROR: Can't find answers for event_id:"
  
  let result = JSON()

  return result
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
