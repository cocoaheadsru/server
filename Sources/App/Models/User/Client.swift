import Vapor
import FluentProvider
import HTTP

final class Client: Model {

  let storage = Storage()

  var id: Identifier
  var pushToken: String
  var userId: Identifier

  private struct Keys {
    static let id = "id"
    static let pushToken = "push_token"
    static let userId = "user_id"
  }

  init(id: String, pushToken: String, userId: String) {
    self.id = Identifier.string(id, in: nil)
    self.pushToken = pushToken
    self.userId = Identifier.string(userId, in: nil)
  }

  init(row: Row) throws {
    id = try row.get(Keys.id)
    pushToken = try row.get(Keys.pushToken)
    userId = try row.get(Keys.userId)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.id, id)
    try row.set(Keys.pushToken, pushToken)
    try row.set(Keys.userId, userId)
    return row
  }
}

// MARK: Fluent Preparation

extension Client: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Keys.pushToken)
      builder.foreignId(for: User.self)

    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension Client: JSONConvertible {
  convenience init(json: JSON) throws {
    self.init(
      id: try json.get(Keys.id),
      pushToken: try json.get(Keys.pushToken),
      userId: try json.get(Keys.userId)
    )
  }

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.pushToken, pushToken)
    try json.set(Keys.userId, userId)
    return json
  }
}

