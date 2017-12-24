// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Content {
  static var entity: String = "content"
}

extension Content {

  struct Keys {
    static let id = "id"
    static let speechId = "speech_id"
    static let type = "type"
    static let title = "title"
    static let description = "description"
    static let link = "link"
  }
}

extension Content {

  enum ContentType {
    case video
    case slide

    var string: String {
      return String(describing: self)
    }

    init(_ string: String) {
      switch string {
      case "video": self = .video
      default: self = .slide
      }
    }
  }
}

extension Content: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.parent(Speech.self, optional: false, unique: false, foreignIdKey: Keys.speechId)
      builder.enum(Keys.type, options: ["video", "slide"])
      builder.string(Keys.title)
      builder.string(Keys.description)
      builder.string(Keys.link)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Content: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.speechId, speechId)
    try json.set(Keys.type, type.string)
    try json.set(Keys.title, title)
    try json.set(Keys.description, description)
    try json.set(Keys.link, link)
    return json
  }
}
