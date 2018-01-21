// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Rule {
  static var entity: String = "rule"
}

extension Rule {

  struct Keys {
    static let id = "id"
    static let type = "type"
  }
}

extension Rule {

  enum ValidationRule {
    case phone
    case number
    case alphanumeric
    case email
    case string

    var string: String {
      return String(describing: self)
    }

    init(_ string: String) {
      switch string {
      case "phone": self = .phone
      case "number": self = .number
      case "alphanumeric": self = .alphanumeric
      case "email": self = .email
      default: self = .string
      }
    }
  }
}

extension Rule: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.enum(Keys.type, options: ["phone", "number", "alphanumeric", "email", "string"])
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Rule: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.type, type.string)
    return json
  }
}
