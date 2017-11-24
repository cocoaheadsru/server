// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Client {

  struct Keys {
    static let id = "id"
    static let userId = "user_id"
    static let pushToken = "push_token"
  }
}

extension Client: ResponseRepresentable { }

extension Client: Updateable {

  public static var updateableKeys: [UpdateableKey<Client>] {
    return [
      UpdateableKey(Keys.userId, Identifier.self) { $0.userId = $1 },
      UpdateableKey(Keys.pushToken, String.self) { $0.pushToken = $1 }
    ]
  }
}

extension Client: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      pushToken: try json.get(Keys.pushToken),
      userId: try json.get(Keys.userId)
    )
  }
}

extension Client: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignKey(Keys.userId, references: User.Keys.id, on: User.self)
      builder.string(Keys.pushToken)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Client: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.userId, userId)
    try json.set(Keys.pushToken, pushToken)
    return json
  }
}
