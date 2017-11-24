import Vapor
import FluentProvider
import HTTP

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation, Updateable, ResponseRepresentable
final class Client: Model {
  
  static var entity: String = "client"

  let storage = Storage()

  // sourcery: relation = foreignId, relatedModel = User
  var userId: Identifier
  var pushToken: String

  init(pushToken: String, userId: Identifier) {
    self.pushToken = pushToken
    self.userId = userId
  }
  
  // sourcery:inline:auto:Client.AutoModelGeneratable

  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    pushToken = try row.get(Keys.pushToken)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.pushToken, pushToken)
    return row
  }
  // sourcery:end
}

extension Client {

  convenience init(request: Request) throws {
    self.init(
      pushToken: try request.json!.get(Keys.pushToken),
      userId: (try request.parameters.next(User.self).id)!
    )
  }
}