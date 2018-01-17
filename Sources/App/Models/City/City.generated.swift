// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension City {
  static var entity: String = "city"
}

extension City {

  struct Keys {
    static let id = "id"
    static let cityName = "city_name"
  }
}

extension City: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Keys.cityName)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension City: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.cityName, cityName)
    return json
  }
}
