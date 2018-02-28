import Vapor
import FluentProvider
import AuthProvider
import Crypto

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, Preparation, Updateable, ResponseRepresentable, Timestampable
final class User: Model {

  let storage = Storage()
  
  var name: String
  var lastname: String?
  var company: String?
  var position: String?
  var photo: String?
  var email: String?
  var phone: String?

  // sourcery: ignoreInJSON
  var token: String? {

    get {
      guard let result  = try? session()?.token else {
       return nil
      }
      return result
    }

    set {
      guard
        let newToken = newValue,
        // swiftlint:disable force_try
        let session = try! session()
      else {
        return
      }
      // swiftlint:disable force_try
      session.token = newToken
      try! session.save()
    }

  }

  init(name: String,
       lastname: String? = nil,
       company: String? = nil,
       position: String? = nil,
       photo: String? = nil,
       email: String? = nil,
       phone: String? = nil) {
    self.name = name
    self.lastname = lastname
    self.company = company
    self.position = position
    self.photo = photo
    self.email = email
    self.phone = phone
  }

  // sourcery:inline:auto:User.AutoModelGeneratable
  init(row: Row) throws {
    name = try row.get(Keys.name)
    lastname = try? row.get(Keys.lastname)
    company = try? row.get(Keys.company)
    position = try? row.get(Keys.position)
    photo = try? row.get(Keys.photo)
    email = try? row.get(Keys.email)
    phone = try? row.get(Keys.phone)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.name, name)
    try? row.set(Keys.lastname, lastname)
    try? row.set(Keys.company, company)
    try? row.set(Keys.position, position)
    try? row.set(Keys.photo, photo)
    try? row.set(Keys.email, email)
    try? row.set(Keys.phone, phone)
    return row
  }
  // sourcery:end
}

extension User: JSONRepresentable {
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.name, name)
    try? json.set(Keys.lastname, lastname)
    try? json.set(Keys.company, company)
    try? json.set(Keys.position, position)
    try? json.set(Keys.photoURL, photoURL())
    try? json.set(Keys.email, email)
    try? json.set(Keys.phone, phone)
    try json.set(Session.Keys.token, token)
    return json
  }

  // sourcery: nestedJSONField
  func  photoURL() -> String? {
    guard
      let photoPath = self.photo,
      let userId = self.id?.string
    else {
      return self.photo
    }
    let photosFolder = Constants.Path.userPhotos
    return "\(photosFolder)/\(userId)/\(photoPath)"
  }

}

// MARK: Token
extension User {

  func updateSessionToken() throws {
    guard let session = try? self.session() else {
      throw Abort(.internalServerError, reason: "Can't get session for User\(self.id?.int ?? -1)")
    }
    try session?.updateToken()
  }
}

// MARK: Relations
extension User {
  
  var clients: Children<User, Client> {
    return children()
  }

  private var sessions: Children<User, Session> {
    return children()
  }

  func session() throws -> Session? {
    return try sessions.first()
  }

}

// MARK: Lifecycle
extension User {
  func didCreate() {
    do {
      let session = try Session(user: self)
      try session.save()
    } catch {
      try? self.delete()
    }
  }

  func didUpdate() {
    try? updateSessionToken()
  }

}

// MARK: TokenAuthenticationMiddleware
extension User: TokenAuthenticatable {
  typealias TokenType = Session
}
