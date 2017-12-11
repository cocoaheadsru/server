// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Heartbeat {

  struct Keys {
    static let id = "id"
    static let beat = "beat"
  }
}

extension Heartbeat: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.int(Keys.beat)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Heartbeat: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.beat, beat)
    return json
  }
}
