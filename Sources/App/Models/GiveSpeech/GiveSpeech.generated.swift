// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension GiveSpeech {
  static var entity: String = "give_speech"
}

extension GiveSpeech {

  struct Keys {
    static let id = "id"
    static let userId = "user_id"
    static let title = "title"
    static let description = "description"
  }
}

extension GiveSpeech: ResponseRepresentable { }

extension GiveSpeech: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      title: try json.get(Keys.title),
      description: try json.get(Keys.description),
      userId: try json.get(Keys.userId)
    )
  }
}

extension GiveSpeech: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: User.self, optional: false, unique: false, foreignIdKey: Keys.userId, foreignKeyName: self.entity + "_" + Keys.userId)
      builder.string(Keys.title)
      builder.string(Keys.description)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension GiveSpeech: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.userId, userId)
    try json.set(Keys.title, title)
    try json.set(Keys.description, description)
    return json
  }
}
