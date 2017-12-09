// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension SocialAccount {
  static var entity: String = "social_account"
}

extension SocialAccount {

  struct Keys {
    static let id = "id"
    static let userId = "user_id"
    static let socialId = "social_id"
    static let socialUserId = "social_user_id"
  }
}

extension SocialAccount: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      userId: try json.get(Keys.userId),
      socialId: try json.get(Keys.socialId),
      socialUserId: try json.get(Keys.socialUserId)
    )
  }
}

extension SocialAccount: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(User.self, optional: false, unique: false, foreignIdKey: Keys.userId)
      builder.parent(Social.self, optional: false, unique: false, foreignIdKey: Keys.socialId)
      builder.string(Keys.socialUserId)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension SocialAccount: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.userId, userId)
    try json.set(Keys.socialId, socialId)
    try json.set(Keys.socialUserId, socialUserId)
    return json
  }
}
