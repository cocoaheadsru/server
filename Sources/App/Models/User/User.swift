import Vapor
import FluentProvider
import HTTP

final class User: Model {

  let storage = Storage()

  var name: String
  var lastname: String
  var company: String
  var position: String
  var photo: String
  var email: String
  var phone: String

  struct Keys {
    static let id = "id"
    static let name = "name"
    static let lastname = "lastname"
    static let company = "company"
    static let position = "position"
    static let photo = "photo"
    static let email = "email"
    static let phone = "phone"

  }

  init(name: String, lastname: String) {
    self.name = name
    self.lastname = lastname
    self.company = ""
    self.phone = ""
    self.email = ""
    self.phone = ""
  }

  init(row: Row) throws {
    id = try row.get(Post.Keys.id)
    name = try row.get(Post.Keys.name)
    lastname = try row.get(Post.Keys.lastname)
    company = try row.get(Post.Keys.company)
    position = try row.get(Post.Keys.position)
    photo = try row.get(Post.Keys.photo)
    email = try row.get(Post.Keys.email)
    phone = try row.get(Post.Keys.phone)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(User.Keys.id, id)
    try row.set(User.Keys.name, name)
    try row.set(User.Keys.lastname, lastname)
    try row.set(User.Keys.company, company)
    try row.set(User.Keys.position, position)
    try row.set(User.Keys.photo, photo)
    try row.set(User.Keys.email, email)
    try row.set(User.Keys.phone, phone)
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
