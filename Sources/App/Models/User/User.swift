import Vapor
import FluentProvider
import AuthProvider
import Crypto

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, Preparation, Updateable, ResponseRepresentable, Timestampable
final class User: Model {

  let storage = Storage()
  
  var name: String
  var lastname: String
  var company: String?
  var position: String?
  var photo: String?
  var email: String?
  var phone: String?

  init(name: String,
       lastname: String,
       company: String?,
       position: String?,
       photo: String?,
       email: String?,
       phone: String?) {
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
    lastname = try row.get(Keys.lastname)
    company = try? row.get(Keys.company)
    position = try? row.get(Keys.position)
    photo = try? row.get(Keys.photo)
    email = try? row.get(Keys.email)
    phone = try? row.get(Keys.phone)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.name, name)
    try row.set(Keys.lastname, lastname)
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
    try json.set(Keys.lastname, lastname)
    try? json.set(Keys.company, company)
    try? json.set(Keys.position, position)
    try? json.set(Keys.photo, photoURL(for: photo))
    try? json.set(Keys.email, email)
    try? json.set(Keys.phone, phone)
    try json.set("session", session()?.makeJSON())
    return json
  }
  
  func photoURL(for photo: String?) -> String? {
    guard
      let config = try? Config(),
      let domain = config["server", "domain"]?.string,
      let userId = self.id?.string,
      let photoPath = photo
    else {
      return nil
    }
    let photosFolder = Constants.Path.userPhotos
    return "\(domain)/\(photosFolder)/\(userId)/\(photoPath)"
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

  // sourcery: nestedJSONField
  func token() throws -> String {
    guard let token = try session()?.token else {
     throw Abort(.internalServerError, reason: "User no have token")
    }
    return token
  }

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

  func updateSessionToken() throws {
    try Session.updateToken(for: self)
  }

}

extension User: TokenAuthenticatable {
  typealias TokenType = Session
}
