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

extension Session: Updateable {

  public static var updateableKeys: [UpdateableKey<Session>] {
    return [
      UpdateableKey(Keys.userId, Identifier.self) { $0.userId = $1 },
      UpdateableKey(Keys.token, String.self) { $0.token = $1 },
      UpdateableKey(Keys.actual, Bool.self) { $0.actual = $1 }
    ]
  }
}

extension Session: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      userId: try json.get(Keys.userId),
      token: try json.get(Keys.token),
      actual: try json.get(Keys.actual)
    )
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

extension Session: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.userId, userId)
    try json.set(Keys.token, token)
    try json.set(Keys.actual, actual)
    return json
  }
}

extension Session: Timestampable { }
