// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension RegField {

  struct Keys {
    static let id = "id"
    static let name = "name"
    static let type = "type"
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

extension RegField: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Keys.name)
      builder.string(Keys.type)
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
    try json.set(Keys.name, name)
    try json.set(Keys.type, type.string)
    return json
  }
}
