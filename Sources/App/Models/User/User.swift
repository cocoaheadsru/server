import Vapor
import FluentProvider
import HTTP

final class User: Model {

  let storage = Storage()

  var id: Node
  var name: String
  var lastname: String
  var company: String
  var position: String
  var photo: String
  var email: String
  var phone: String

  private struct Keys {
    static let id = "id"
    static let name = "name"
    static let lastname = "lastname"
    static let company = "company"
    static let position = "position"
    static let photo = "photo"
    static let email = "email"
    static let phone = "phone"

  }

  init(id: String, name: String, lastname: String, company: String = "", position: String = "", photo: String = "", email: String = "", phone: String = "") {
    self.id = Node(id, in: nil)
    self.name = name
    self.lastname = lastname
    self.company = company
    self.position = position
    self.photo = photo
    self.email = email
    self.phone = phone
  }

  init(row: Row) throws {
    id = try row.get(Keys.id)
    name = try row.get(Keys.name)
    name = try row.get(Keys.name)
    lastname = try row.get(Keys.lastname)
    company = try row.get(Keys.company)
    position = try row.get(Keys.position)
    photo = try row.get(Keys.photo)
    email = try row.get(Keys.email)
    phone = try row.get(Keys.phone)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.id, id)
    try row.set(Keys.name, name)
    try row.set(Keys.lastname, lastname)
    try row.set(Keys.company, company)
    try row.set(Keys.position, position)
    try row.set(Keys.photo, photo)
    try row.set(Keys.email, email)
    try row.set(Keys.phone, phone)
    return row
  }
}

// MARK: Fluent Preparation

extension User: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(User.Keys.name)
      builder.string(User.Keys.lastname)
      builder.string(User.Keys.company)
      builder.string(User.Keys.position)
      builder.string(User.Keys.photo)
      builder.string(User.Keys.email)
      builder.string(User.Keys.phone)
      
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension User: JSONConvertible {
  convenience init(json: JSON) throws {
    self.init(

      id: try json.get(Keys.id),
      name: try json.get(Keys.name),
      lastname: try json.get(Keys.lastname),
      company: try json.get(Keys.company),
      position: try json.get(Keys.position),
      photo: try json.get(Keys.photo),
      email: try json.get(Keys.email),
      phone: try json.get(Keys.phone)
    )
  }

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(User.Keys.id, id)
    try json.set(User.Keys.name, name)
    try json.set(User.Keys.lastname, lastname)
    try json.set(User.Keys.company, company)
    try json.set(User.Keys.position, position)
    try json.set(User.Keys.photo, photo)
    try json.set(User.Keys.email, email)
    try json.set(User.Keys.phone, phone)
    return json
  }
}

// MARK: Update

extension User: Updateable {

  public static var updateableKeys: [UpdateableKey<User>] {
    return [
      UpdateableKey(Keys.name, String.self) { $0.name = $1 },
      UpdateableKey(Keys.lastname, String.self) { $0.lastname = $1 },
      UpdateableKey(Keys.company, String.self) { $0.company = $1 },
      UpdateableKey(Keys.position, String.self) { $0.position = $1 },
      UpdateableKey(Keys.photo, String.self) { $0.photo = $1 },
      UpdateableKey(Keys.email, String.self) { $0.email = $1 },
      UpdateableKey(Keys.phone, String.self) { $0.phone = $1 },
    ]
  }
}
