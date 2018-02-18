// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Creator {
  static var entity: String = "creator"
}

extension Creator {

  struct Keys {
    static let id = "id"
    static let userId = "user_id"
    static let position = "position"
    static let photoUrl = "photo_url"
    static let info = "info"
    static let url = "url"
    static let active = "active"
  }
}

extension Creator: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: User.self, optional: false, unique: false, foreignIdKey: Keys.userId, foreignKeyName: self.entity + "_" + Keys.userId)
      builder.int(Keys.position)
      builder.string(Keys.photoUrl)
      builder.string(Keys.info)
      builder.string(Keys.url)
      builder.bool(Keys.active)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Creator: ResponseRepresentable { }
