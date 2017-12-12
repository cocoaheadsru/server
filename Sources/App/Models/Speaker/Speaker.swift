import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Speaker: Model {
    
  let storage = Storage()
  
  // sourcery: relation = parent, relatedModel = User
  var userId: Identifier
  // sourcery: relation = parent, relatedModel = Speech
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
