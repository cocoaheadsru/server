import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, fromJSON, Preparation, ResponseRepresentable
final class GiveSpeech: Model {
  
  let storage = Storage()

  var userId: Identifier
  var title: String
  var description: String
  
  init(title: String,
       description: String,
       userId: Identifier) {
    self.title = title
    self.description = description
    self.userId = userId
  }
  
  // sourcery:inline:auto:GiveSpeech.AutoModelGeneratable
  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    return row
  }
  // sourcery:end
}

extension GiveSpeech {

  func user() throws -> User? {
    return try parent(id: userId).get()
  }
}
