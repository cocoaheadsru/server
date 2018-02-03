import Vapor
import FluentProvider
import Foundation

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation, Updateable, ResponseRepresentable, Timestampable
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
  
  func didCreate() {
    let token = UUID().uuidString
    do {
      let userId = try self.assertExists()
      let session = Session(userId: userId, token: token)
      try session.save()
    } catch {
      try? self.delete()
    }
  }
  
  func updateSessionToken() throws {
    guard let session = try self.session(), let updatedAt = session.updatedAt else {
      throw Abort.notFound
    }
    if let referenceDate = Calendar.current.date(byAdding: .month, value: 1, to: updatedAt),
      referenceDate < Date() {
      session.token = UUID().uuidString
      try session.save()
    }
  }
}
