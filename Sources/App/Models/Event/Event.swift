import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: Preparation, Timestampable, Updateable
final class Event: Model {
    
  let storage = Storage()
  
  // sourcery: ignoreInJSON
  var placeId: Identifier
  var title: String
  var description: String
  var photoUrl: String
  var isRegistrationOpen: Bool = true
  var startDate: Date
  var endDate: Date
  var hide: Bool = false
  
  init(title: String,
       description: String,
       photoUrl: String,
       placeId: Identifier,
       isRegistrationOpen: Bool = true,
       startDate: Date,
       endDate: Date,
       hide: Bool = false) {
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
    
    func makeJSON(with request: Request) throws -> JSON {
        var json = JSON()
        try json.set(Keys.id, id)
        try json.set(Keys.title, title)
        try json.set(Keys.description, description)
        try json.set(Keys.photoUrl, photoUrl)
        try json.set(Keys.isRegistrationOpen, isRegistrationOpen)
        try json.set(Keys.startDate, startDate.mysqlString)
        try json.set(Keys.endDate, endDate.mysqlString)
        try json.set(Keys.hide, hide)
        try json.set(Keys.place, place()?.makeJSON())
        try json.set(Keys.status, status(for: request))
        try json.set(Keys.speakersPhotos, speakersPhotos())
        return json
    }
}

extension Event {
  
  func place() throws -> Place? {
    return try parent(id: placeId).get()
  }

  func speeches() throws -> [Speech] {
    return try children().all()
  }
  
  func status(for request: Request) throws -> String {

    if request.auth.isAuthenticated(User.self) {
      let userId = try request.user().id
      let eventRegForm = try RegForm.makeQuery().filter(RegForm.Keys.eventId, id).first()
      let registration = try EventReg
        .makeQuery()
        .filter(EventReg.Keys.status, .notEquals, EventReg.RegistrationStatus.canceled.string)
        .filter(EventReg.Keys.userId, .equals, userId)
        .filter(EventReg.Keys.regFormId, .equals, eventRegForm?.id)
        .first()
      
      if let status = registration?.status.string {
        return status
      }
    }
    
    if !isRegistrationOpen {
      return Constants.Status.Registration.closed
    }
    return Constants.Status.Registration.canRegister
  }
  
  func speakersPhotos() throws -> [String] {
    return try speeches().flatMap { speech in
        return try speech.speakers().flatMap { speaker in
            return try speaker.user()?.photoURL
        }
    }
  }
  
  func registrationForm() throws -> RegForm? {
    return try children().first()
  }
}
