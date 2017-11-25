import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation
final class SocialAccount: Model {
  
  static var entity: String = "social_account"
  
  let storage = Storage()
  
  // sourcery: relation = parent, relatedModel = User
  var userId: Identifier
  // sourcery: relation = parent, relatedModel = Social
  var socialId: Identifier
  var socialUserId: String
  
  init(userId: Identifier,
       socialId: Identifier,
       socialUserId: String) {
    self.socialId = socialId
    self.socialUserId = socialUserId
    self.userId = userId
  }
  
  // sourcery:inline:auto:SocialAccount.AutoModelGeneratable

  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    socialId = try row.get(Keys.socialId)
    socialUserId = try row.get(Keys.socialUserId)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.socialId, socialId)
    try row.set(Keys.socialUserId, socialUserId)
    return row
  }
  // sourcery:end
}

extension SocialAccount {
  
  func social() throws -> Social? {
    return try parent(id: socialId).get()
  }
}
