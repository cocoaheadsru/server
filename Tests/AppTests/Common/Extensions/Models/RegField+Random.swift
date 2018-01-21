import Vapor
@testable import App

extension RegField {
  
  convenience init(_ randomInit: Bool = true,
                   fieldTypeNumber: Int = Int.random(min: 0, max: FieldType.count-1),
                   regFormId: Identifier) {
    let regFieldType = ["checkbox", "radio", "string"]
    
    if randomInit {
      self.init(
        regFormId: regFormId,
        required: Bool.randomValue,
        name: String.randomValue,
        type: RegField.FieldType(regFieldType[fieldTypeNumber]),
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

extension RegField.FieldType {
  static let count = 3
}
