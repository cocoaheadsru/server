import HTTP
import Vapor

final class  RegistrationController {
  
  func index(_ req: Request) throws -> ResponseRepresentable {
    
    guard let eventId = req.parameters["id"]?.int else {
      return try Response(
        status: .badRequest,
        message: "EventId parameters is missing in URL request"
      )
    }
    
    guard let regForm = try RegForm.getRegFormBy(eventId) else {
      return try Response(
        status: .notFound,
        message: "Can't find RegForm by event_id: \(eventId)"
      )
    }
    
    guard let regFields = try RegField.getEventRegFieldBy(regForm.id!), regFields.count > 0 else {
      return try Response(
        status: .notFound,
        message: "Can't find RegFields by event_id: \(eventId) and regform_id: \(regForm.id?.int ?? 0)"
      )
    }
    
    //guard try RegField.makeQuery().filter("field_id")
    
    var regFieldsJSON = try regFields.makeJSON()
    regFieldsJSON.removeKey("id")
    regFieldsJSON.removeKey("reg_form_id")
    
    var result = try regForm.makeJSON()
    try result.set(Keys.regFields, regFieldsJSON)
    
    return result
  }
}

extension RegistrationController: ResourceRepresentable {
  
  func makeResource() -> Resource<RegForm> {
    return Resource(
      index: index
    )
  }
}

extension RegistrationController: EmptyInitializable { }
