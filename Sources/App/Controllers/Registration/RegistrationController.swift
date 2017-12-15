import HTTP
import Vapor

final class  RegistrationController {
  
  func index(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int else {
      return Response(status: .badRequest)
    }
    
    guard let regForm = try RegForm.find(id) else {
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

extension RegistrationController : EmptyInitializable { }

