import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: Preparation
final class Speaker: Model {
    
  let storage = Storage()
  
  var userId: Identifier
  var speechId: Identifier
  
  init(userId: Identifier, speechId: Identifier) {
    self.userId = userId
    self.speechId = speechId
  }

  // sourcery:inline:auto:Speaker.AutoModelGeneratable
  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    speechId = try row.get(Keys.speechId)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.speechId, speechId)
    return row
  }
  // sourcery:end
}

extension Speaker {
  
  func user() throws -> User? {
    return try parent(id: userId).get()
  }
  
  func speech() throws -> Speech? {
    return try parent(id: speechId).get()
  }
}

/// Custom implementation because of this exceptional case
extension Speaker: JSONRepresentable {
  
  func makeJSON() throws -> JSON {
    guard let userJSON = try user()?.makeJSON() else {
      throw Abort(.internalServerError, reason: "Speaker doesn't have associated User")
    }
    var json = JSON(json: userJSON)
    json.removeKey(Session.Keys.token)
    return json
  }
}
