import Vapor
import FluentProvider

final class Creator: Model {
  
  let storage = Storage()
  
  var userId: Identifier
  var position: Int
  var photoUrl: String
  var info: String
  var url: String
  var isActive: Bool
  
  struct Keys {
    static let id = "id"
    static let userId = "user_id"
    static let position = "position"
    static let photoUrl = "photo_url"
    static let info = "info"
    static let url = "url"
    static let isActive = "active"
  }
  
  init(userId: Identifier, position: Int, photoUrl: String, info: String, url: String, isActive: Bool) {
    self.userId = userId
    self.position = position
    self.photoUrl = photoUrl
    self.info = info
    self.url = url
    self.isActive = isActive
  }
  
  // MARK: Fluent Serialization
  
  init(row: Row) throws {
    userId = try row.get(Creator.Keys.userId)
    position = try row.get(Creator.Keys.position)
    photoUrl = try row.get(Creator.Keys.photoUrl)
    info = try row.get(Creator.Keys.info)
    url = try row.get(Creator.Keys.url)
    isActive = try row.get(Creator.Keys.isActive)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Creator.Keys.userId, userId)
    try row.set(Creator.Keys.position, position)
    try row.set(Creator.Keys.photoUrl, photoUrl)
    try row.set(Creator.Keys.info, info)
    try row.set(Creator.Keys.url, url)
    try row.set(Creator.Keys.isActive, isActive)
    return row
  }
}

extension Creator {
  //    Uncomment when User model is created
  //    func user() throws -> User? {
  //        return try children().first()
  //    }
}

// MARK: Fluent Preparation

extension Creator: Preparation {
  
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      // Uncomment when User model is created
      //builder.foreignKey(Creator.Keys.userId, references: User.Keys.id, on: User.self, named: "user")
      builder.int(Creator.Keys.position)
      builder.string(Creator.Keys.photoUrl)
      builder.string(Creator.Keys.info)
      builder.string(Creator.Keys.url)
      builder.bool(Creator.Keys.isActive)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension Creator: JSONRepresentable {
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Creator.Keys.id, id)
    try json.set(Creator.Keys.userId, userId)
    try json.set(Creator.Keys.position, position)
    try json.set(Creator.Keys.photoUrl, photoUrl)
    try json.set(Creator.Keys.info, info)
    try json.set(Creator.Keys.url, url)
    try json.set(Creator.Keys.isActive, isActive)
    return json
  }
}

// MARK: HTTP

extension Creator: ResponseRepresentable { }
