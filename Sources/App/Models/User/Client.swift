import Vapor
import FluentProvider
import HTTP

final class Client: Model {

  let storage = Storage()

  var pushToken: String
  var userId: Identifier

  private struct Keys {
    static let id = "id"
    static let pushToken = "push_token"
    static let userId = "user_id"
  }

  init(pushToken: String, userId: String) {
    self.pushToken = pushToken
    self.userId = Identifier.string(userId, in: nil)
  }

  init(row: Row) throws {
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
      pushToken: try json.get(Keys.pushToken),
      userId: try json.get(Keys.userId)
    )
  }
  
  convenience init(request: Request) throws {
    self.init(
      pushToken: try request.json!.get(Keys.pushToken),
      userId: (try request.parameters.next(User.self).id?.string)!
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

// MARK: Update
extension Client: Updateable {
  public static var updateableKeys: [UpdateableKey<Client>] {
    return [
      UpdateableKey(Keys.pushToken, String.self) { $0.pushToken = $1 }
    ]
  }
}

extension Client: ResponseRepresentable {}
