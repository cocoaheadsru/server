import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Event: Model {
  
  static var entity: String = "event"
  
  let storage = Storage()
  
  // sourcery: relatedModel = Place
  var placeId: Identifier
  var title: String
  var description: String
  var photoUrl: String
  var isRegistrationOpen: Bool = true
  var startDate: Int
  var endDate: Int
  var hide: Bool = false
  
  init(title: String, description: String, photoUrl: String, placeId: Identifier, isRegistrationOpen: Bool = true, startDate: Int, endDate: Int, hide: Bool = false) {
    self.title = title
    self.description = description
    self.photoUrl = photoUrl
    self.placeId = placeId
    self.isRegistrationOpen = isRegistrationOpen
    self.startDate = startDate
    self.endDate = endDate
    self.hide = hide
  }
  
  // sourcery:inline:auto:Event.AutoModelGeneratable

  init(row: Row) throws {
    placeId = try row.get(Keys.placeId)
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
    photoUrl = try row.get(Keys.photoUrl)
    isRegistrationOpen = try row.get(Keys.isRegistrationOpen)
    startDate = try row.get(Keys.startDate)
    endDate = try row.get(Keys.endDate)
    hide = try row.get(Keys.hide)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.placeId, placeId)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    try row.set(Keys.photoUrl, photoUrl)
    try row.set(Keys.isRegistrationOpen, isRegistrationOpen)
    try row.set(Keys.startDate, startDate)
    try row.set(Keys.endDate, endDate)
    try row.set(Keys.hide, hide)
    return row
  }
  // sourcery:end
}

extension Event {
  
  func place() throws -> Place? {
    return try children().first()
  }
  
  func speeches() throws -> [Speech] {
    return try Speech.makeQuery().filter(Speech.Keys.eventId, id).all()
  }
  
  func status() -> String {
    return ""
  }
  
  func registrationForm() throws -> RegForm? {
    return try RegForm.makeQuery().filter(RegForm.Keys.eventId, id).first()
  }
}
