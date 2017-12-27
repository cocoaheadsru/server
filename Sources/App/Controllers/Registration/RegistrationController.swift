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
  
    var result: JSON = [:]
    try result.set("id", regForm.id!)
    try result.set("form_name", regForm.formName)
    try result.set("description", regForm.description)
    
    var regFieldsJSON: [JSON] = []
    for regField in regFields {
      var json: JSON = [:]
      try json.set("field_id", regField.id!)
      try json.set("should_save", regField.shouldSave)
      try json.set("required", regField.required)
      var fields: JSON = [:]
      try fields.set("name", regField.name)
      try fields.set("type", regField.type.string)
      try fields.set("field_answers", try RegFieldAnswer.makeQuery().filter("field_id", regField.id!).all().makeJSON())
      try json.set("field", fields)
      regFieldsJSON.append(json)
    }
    try result.set("reg_fields", regFieldsJSON)
    //result.makeResponse()
    return  Response(
      status: .ok,
      headers: ["Content-Type": "application/json"],
      body: result)
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
