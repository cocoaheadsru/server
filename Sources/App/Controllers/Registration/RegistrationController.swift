import HTTP
import Vapor

final class  RegistrationController {
  
  func index(_ req: Request) throws -> ResponseRepresentable {
    guard let eventId = req.parameters["id"]?.int else {
      return Response(status: .badRequest)
    }
    
    guard let regForm = try RegForm.makeQuery().filter("event_id",eventId).first() else {
      return Response(status: .notFound)
    }
    
    return try regForm.makeJSON()
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

