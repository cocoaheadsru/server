// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Session {

  struct Keys {
    static let id = "id"
    static let userId = "user_id"
    static let token = "token"
    static let actual = "actual"
    static let timestamp = "timestamp"
  }
}

extension Session: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      userId: try json.get(Keys.userId),
      token: try json.get(Keys.token),
      actual: try json.get(Keys.actual),
      timestamp: try json.get(Keys.timestamp)
    )
  }
}

extension Session: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(User.self, optional: false, unique: false, foreignIdKey: Keys.userId)
      builder.string(Keys.token)
      builder.bool(Keys.actual)
      builder.int(Keys.timestamp)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Session: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.userId, userId)
    try json.set(Keys.token, token)
    try json.set(Keys.actual, actual)
    try json.set(Keys.timestamp, timestamp)
    return json
  }
}
