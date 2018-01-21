// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Event {
  static var entity: String = "event"
}

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
    static let place = "place"
    static let status = "status"
    static let speakersPhotos = "speakers_photos"
  }
}

extension Event: Updateable {

  public static var updateableKeys: [UpdateableKey<Event>] {
    return [
      UpdateableKey(Keys.placeId, Identifier.self) { $0.placeId = $1 },
      UpdateableKey(Keys.title, String.self) { $0.title = $1 },
      UpdateableKey(Keys.description, String.self) { $0.description = $1 },
      UpdateableKey(Keys.photoUrl, String.self) { $0.photoUrl = $1 },
      UpdateableKey(Keys.isRegistrationOpen, Bool.self) { $0.isRegistrationOpen = $1 },
      UpdateableKey(Keys.startDate, Date.self) { $0.startDate = $1 },
      UpdateableKey(Keys.endDate, Date.self) { $0.endDate = $1 },
      UpdateableKey(Keys.hide, Bool.self) { $0.hide = $1 }
    ]
  }
}

extension Event: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.foreignId(for: Place.self, optional: false, unique: false, foreignIdKey: Keys.placeId, foreignKeyName: self.entity + "_" + Keys.placeId)
      builder.string(Keys.title)
      builder.string(Keys.description)
      builder.string(Keys.photoUrl)
      builder.bool(Keys.isRegistrationOpen)
      builder.date(Keys.startDate)
      builder.date(Keys.endDate)
      builder.bool(Keys.hide)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Event: Timestampable { }
