// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Event {

  struct Keys {
    static let id = "id"
    static let placeId = "place_id"
    static let title = "title"
    static let description = "description"
    static let photoUrl = "photo_url"
    static let isRegistrationOpen = "is_registration_open"
    static let startDate = "start_date"
    static let endDate = "end_date"
    static let hide = "hide"
  }
}

extension Event: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: Place.self, optional: false, unique: false, foreignIdKey: Keys.placeId)
      builder.string(Keys.title)
      builder.string(Keys.description)
      builder.string(Keys.photoUrl)
      builder.bool(Keys.isRegistrationOpen)
      builder.int(Keys.startDate)
      builder.int(Keys.endDate)
      builder.bool(Keys.hide)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Event: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.placeId, placeId)
    try json.set(Keys.title, title)
    try json.set(Keys.description, description)
    try json.set(Keys.photoUrl, photoUrl)
    try json.set(Keys.isRegistrationOpen, isRegistrationOpen)
    try json.set(Keys.startDate, startDate)
    try json.set(Keys.endDate, endDate)
    try json.set(Keys.hide, hide)
    return json
  }
}
