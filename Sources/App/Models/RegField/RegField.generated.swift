// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension RegField {
  static var entity: String = "reg_field"
}

extension RegField {

  struct Keys {
    static let id = "id"
    static let regFormId = "reg_form_id"
    static let required = "required"
    static let type = "type"
    static let name = "name"
    static let placeholder = "placeholder"
    static let defaultValue = "default_value"
    static let fieldAnswers = "field_answers"
  }
}

extension RegField {

  enum FieldType {
    case checkbox
    case radio
    case string

    var string: String {
      return String(describing: self)
    }

    init(_ string: String) {
      switch string {
      case "checkbox": self = .checkbox
      case "radio": self = .radio
      default: self = .string
      }
    }
  }
}

extension RegField: Updateable {

  public static var updateableKeys: [UpdateableKey<RegField>] {
    return [
      UpdateableKey(Keys.regFormId, Identifier.self) { $0.regFormId = $1 },
      UpdateableKey(Keys.required, Bool.self) { $0.required = $1 },
      UpdateableKey(Keys.type, String.self) { $0.type = FieldType($1) },
      UpdateableKey(Keys.name, String.self) { $0.name = $1 },
      UpdateableKey(Keys.placeholder, String.self) { $0.placeholder = $1 },
      UpdateableKey(Keys.defaultValue, String.self) { $0.defaultValue = $1 }
    ]
  }
}

extension RegField: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      regFormId: try json.get(Keys.regFormId),
      required: try json.get(Keys.required),
      name: try json.get(Keys.name),
      type: FieldType(try json.get(Keys.type)),
      placeholder: try json.get(Keys.placeholder),
      defaultValue: try json.get(Keys.defaultValue)
    )
  }
}

extension RegField: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: RegForm.self, optional: false, unique: false, foreignIdKey: Keys.regFormId, foreignKeyName: self.entity + "_" + Keys.regFormId)
      builder.bool(Keys.required)
      builder.enum(Keys.type, options: ["checkbox", "radio", "string"])
      builder.string(Keys.name)
      builder.string(Keys.placeholder)
      builder.string(Keys.defaultValue)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension RegField: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.required, required)
    try json.set(Keys.type, type.string)
    try json.set(Keys.name, name)
    try json.set(Keys.placeholder, placeholder)
    try json.set(Keys.defaultValue, defaultValue)
    try json.set(Keys.fieldAnswers, fieldAnswers().makeJSON())
    return json
  }
}
