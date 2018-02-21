import HTTP
import Vapor
import Fluent

final class  RegistrationFormController {
  
  func index(_ request: Request) throws -> ResponseRepresentable {
    
    guard let eventId = request.parameters["id"]?.int else {
      throw Abort(.badRequest, reason: "EventId parameters is missing in URL request")
    }
    
    guard let regForm = try RegForm.getRegForm(by: eventId) else {
      throw Abort(.internalServerError, reason: "Can't find RegForm by event_id: \(eventId)")
    }
    
    return regForm
  }
}

extension RegistrationFormController: ResourceRepresentable {
  
  func makeResource() -> Resource<RegForm> {
    return Resource(
      index: index
    )
  }
}

extension RegistrationFormController: EmptyInitializable { }
