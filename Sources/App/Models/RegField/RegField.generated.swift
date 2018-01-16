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
    static let type = "type"
    static let rules = "rules"
    static let name = "name"
    static let placeholder = "placeholder"
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
      UpdateableKey(Keys.type, String.self) { $0.type = FieldType($1) },
      UpdateableKey(Keys.rules, Array.self) { $0.rules = $1 },
      UpdateableKey(Keys.name, String.self) { $0.name = $1 },
      UpdateableKey(Keys.placeholder, String.self) { $0.placeholder = $1 }
    ]
  }
}

extension RegField: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      name: try json.get(Keys.name),
      type: FieldType(try json.get(Keys.type)),
      placeholder: try json.get(Keys.placeholder),
      rules: try json.get(Keys.rules)
    )
  }
}

extension RegField: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.enum(Keys.type, options: ["checkbox","radio","string"])
      builder.foreignId(for: RegFieldRule.self, optional: false, unique: false, foreignIdKey: Keys.rules)
      builder.string(Keys.name)
      builder.string(Keys.placeholder)
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
    try json.set(Keys.type, type.string)
    try json.set(Keys.rules, rules)
    try json.set(Keys.name, name)
    try json.set(Keys.placeholder, placeholder)
    return json
  }
}
