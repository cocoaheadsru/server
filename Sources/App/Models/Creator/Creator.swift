import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Creator: Model {
  
  static var entity: String = "creator"
  
  let storage = Storage()
  
  // sourcery: relation = foreignId, relatedModel = User
  var userId: Identifier
  var position: Int
  var photoUrl: String
  var info: String
  var url: String
  var active: Bool
  
  init(userId: Identifier, position: Int, photoUrl: String, info: String, url: String, active: Bool) {
    self.userId = userId
    self.position = position
    self.photoUrl = photoUrl
    self.info = info
    self.url = url
    self.active = active
  }
  
  // sourcery:inline:auto:Creator.AutoModelGeneratable

  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    position = try row.get(Keys.position)
    photoUrl = try row.get(Keys.photoUrl)
    info = try row.get(Keys.info)
    url = try row.get(Keys.url)
    active = try row.get(Keys.active)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.position, position)
    try row.set(Keys.photoUrl, photoUrl)
    try row.set(Keys.info, info)
    try row.set(Keys.url, url)
    try row.set(Keys.active, active)
    return row
  }
  // sourcery:end
}

extension Creator {

  func user() throws -> User? {
    return try parent(id: userId).get()
  }
  
  func photo() throws -> String {
    return "http://upapi.ru/photos/creators/\(photoUrl)"
  }
}
