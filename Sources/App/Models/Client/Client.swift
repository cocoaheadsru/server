import Vapor
import FluentProvider
import HTTP

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation, Updateable, ResponseRepresentable, Timestampable
final class Client: Model {
  
  let storage = Storage()

  var userId: Identifier?
  var pushToken: String

  init(pushToken: String, userId: Identifier?) {
    self.pushToken = pushToken
    self.userId = userId
  }
  
  // sourcery:inline:auto:Client.AutoModelGeneratable
  init(row: Row) throws {
    userId = try? row.get(Keys.userId)
    pushToken = try row.get(Keys.pushToken)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try? row.set(Keys.userId, userId)
    try row.set(Keys.pushToken, pushToken)
    return row
  }
  // sourcery:end
}

extension Client {

  convenience init(request: Request) throws {
    self.init(
      pushToken: try request.json!.get(Keys.pushToken),
      userId: try request.user().id
    )
  }

  static func returnIfExists(request: Request) throws -> Client? {
    return try Client.makeQuery()
      .filter(Keys.userId, try request.user().id)
      .first()
  }
}
