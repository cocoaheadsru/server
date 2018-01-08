import Vapor
import Fluent

extension RegistrationController {
  struct Keys {
    static let regFields = "reg_fields"
    static let regFormId = "reg_form_id"
    static let fields = "fields"
    static let userAnswers = "user_answers"
  }
  
  func checkRadio(fieldId: Identifier, answerCount: Int) throws -> Bool {
    let fiedlType = try RegField.find(fieldId)?.type
    if  fiedlType == RegField.FieldType.radio {
      return answerCount <= 1
    } else {
      return true
    }
  }
  
  func checkRequired(fieldId: Identifier, answerCount: Int) throws -> Bool {
    guard let fiedlRequired = try RegField.find(fieldId)?.required else {
      throw Abort.serverError
    }
    
    if fiedlRequired {
      return answerCount > 0
    } else {
      return true
    }
  }
  
}
