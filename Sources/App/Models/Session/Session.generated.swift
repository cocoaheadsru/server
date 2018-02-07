// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Session {
  static var entity: String = "session"
}

extension Session {

  struct Keys {
    static let id = "id"
    static let userId = "user_id"
    static let token = "token"
    static let actual = "actual"
  }
}

extension Session: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: User.self, optional: false, unique: true, foreignIdKey: Keys.userId, foreignKeyName: self.entity + "_" + Keys.userId)
      builder.string(Keys.token)
      builder.bool(Keys.actual)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Session: Timestampable { }
