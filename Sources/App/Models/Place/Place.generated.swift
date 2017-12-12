// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Place {
  static var entity: String = "place"
}

extension Place {

  struct Keys {
    static let id = "id"
    static let cityId = "city_id"
    static let title = "title"
    static let address = "address"
    static let description = "description"
    static let latitude = "latitude"
    static let longitude = "longitude"
  }
}

extension Place: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: City.self, optional: false, unique: false, foreignIdKey: Keys.cityId)
      builder.string(Keys.title)
      builder.string(Keys.address)
      builder.string(Keys.description)
      builder.double(Keys.latitude)
      builder.double(Keys.longitude)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Place: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.cityId, cityId)
    try json.set(Keys.title, title)
    try json.set(Keys.address, address)
    try json.set(Keys.description, description)
    try json.set(Keys.latitude, latitude)
    try json.set(Keys.longitude, longitude)
    return json
  }
}
