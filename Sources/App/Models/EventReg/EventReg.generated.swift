// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension EventReg {

  struct Keys {
    static let id = "id"
    static let regFormId = "reg_form_id"
    static let userId = "user_id"
    static let status = "status"
  }
}

extension EventReg {

  enum RegistrationStatus {
    case approved
    case waiting
    case rejected
    case canceled

    var string: String {
      return String(describing: self)
    }

    init(_ string: String) {
      switch string {
      case "approved": self = .approved
      case "waiting": self = .waiting
      case "rejected": self = .rejected
      default: self = .canceled
      }
    }
  }
}

extension EventReg: Updateable {

  public static var updateableKeys: [UpdateableKey<EventReg>] {
    return [
      UpdateableKey(Keys.regFormId, Identifier.self) { $0.regFormId = $1 },
      UpdateableKey(Keys.userId, Identifier.self) { $0.userId = $1 },
      UpdateableKey(Keys.status, String.self) { $0.status = RegistrationStatus($1) }
    ]
  }
}

extension EventReg: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignKey(Keys.regFormId, references: RegForm.Keys.id, on: RegForm.self)
      builder.parent(User.self, optional: false, unique: false, foreignIdKey: Keys.userId)
      builder.string(Keys.status)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension EventReg: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.regFormId, regFormId)
    try json.set(Keys.userId, userId)
    try json.set(Keys.status, status.string)
    return json
  }
}