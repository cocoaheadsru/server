import Vapor
@testable import App

extension RegField {
  
  convenience init(_ randomInit: Bool = true, regFormId: Identifier) throws {
    let regFieldType = ["checkbox", "radio", "string"]
    
    if randomInit {
      self.init(
        regFormId: regFormId,
        required: Bool.randomValue,
        name: String.randomValue,
        type: RegField.FieldType(regFieldType.randomValue),
        placeholder: String.randomValue,
        defaultValue: String.randomValue)
    } else {
      self.init(
        regFormId: regFormId,
        required: true,
        name: "",
        type: RegField.FieldType(regFieldType[0]),
        placeholder: "",
        defaultValue: "")
    }
  }
  
}
