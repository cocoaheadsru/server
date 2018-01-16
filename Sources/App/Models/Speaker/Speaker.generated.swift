// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Speaker {
  static var entity: String = "speaker"
}

extension Speaker {

  struct Keys {
    static let id = "id"
    static let userId = "user_id"
    static let speechId = "speech_id"
  }
}

extension Speaker: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: User.self, optional: false, unique: false, foreignIdKey: Keys.userId)
      builder.foreignId(for: Speech.self, optional: false, unique: false, foreignIdKey: Keys.speechId)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}
