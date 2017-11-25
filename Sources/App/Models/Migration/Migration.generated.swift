// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Migration {

  struct Keys {
    static let id = "id"
    static let version = "version"
    static let applyTime = "apply_time"
  }
}

extension Migration: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      version: try json.get(Keys.version),
      applyTime: try json.get(Keys.applyTime)
    )
  }
}

extension Migration: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Keys.version)
      builder.int(Keys.applyTime)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Migration: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.version, version)
    try json.set(Keys.applyTime, applyTime)
    return json
  }
}
