import Vapor
import FluentProvider
import HTTP

final class SocialAccount: Model {
  let storage = Storage()
  
  var socialId: String
  var socialUserId: String
  var userId: Int
  
  struct Keys {
    static let id = "id"
    static let socialId = "social_id"
    static let socialUserId  = "social_user_id"
    static let userId = "user_id"
  }
  
  init(socialId: String, socialUserId: String, userId: Int) {
    self.socialId = socialId
    self.socialUserId = socialUserId
    self.userId = userId
  }
  
  init(row: Row) throws {
    socialId = try row.get(SocialAccount.Keys.socialId)
    socialUserId = try row.get(SocialAccount.Keys.socialUserId)
    userId = try row.get(SocialAccount.Keys.userId)
    id = try row.get(SocialAccount.Keys.id)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(SocialAccount.Keys.id, id)
    try row.set(SocialAccount.Keys.socialId, socialId)
    try row.set(SocialAccount.Keys.socialUserId, socialUserId)
    try row.set(SocialAccount.Keys.userId, userId)
    return row
  }
}

// MARK: Fluent Preparation

extension SocialAccount: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignKey(SocialAccount.Keys.socialId, references: Social.Keys.id, on: Social.self, named: "social")
      builder.string(SocialAccount.Keys.socialId)
      builder.string(SocialAccount.Keys.socialUserId)
      builder.string(SocialAccount.Keys.userId)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension SocialAccount: JSONConvertible {
  convenience init(json: JSON) throws {
    try self.init(
      socialId: json.get(SocialAccount.Keys.socialId),
      socialUserId: json.get(SocialAccount.Keys.socialUserId),
      userId: json.get(SocialAccount.Keys.userId))
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(SocialAccount.Keys.id, id)
    try json.set(SocialAccount.Keys.socialId, socialId)
    try json.set(SocialAccount.Keys.socialUserId, socialUserId)
    try json.set(SocialAccount.Keys.userId, userId)
    return json
  }
}
