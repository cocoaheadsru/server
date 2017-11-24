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

  init(name: String,
       lastname: String,
       company: String = "",
       position: String = "",
       photo: String = "",
       email: String = "",
       phone: String = "") {
    self.name = name
    self.lastname = lastname
    self.company = company
    self.position = position
    self.photo = photo
    self.email = email
    self.phone = phone
  }

  init(row: Row) throws {
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
      builder.string(Keys.name)
      builder.string(Keys.lastname)
      builder.string(Keys.company)
      builder.string(Keys.position)
      builder.string(Keys.photo)
      builder.string(Keys.email)
      builder.string(Keys.phone)
      
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension User: JSONConvertible {
  convenience init(json: JSON) throws {
    try self.init(
      name: json.get(Keys.name),
      lastname: json.get(Keys.lastname),
      company: json.get(Keys.company) ?? "",
      position: json.get(Keys.position) ?? "",
      photo: json.get(Keys.photo) ?? "",
      email: json.get(Keys.email) ?? "",
      phone: json.get(Keys.phone) ?? ""
    )
  }

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.name, name)
    try json.set(Keys.lastname, lastname)
    try json.set(Keys.company, company)
    try json.set(Keys.position, position)
    try json.set(Keys.photo, photo)
    try json.set(Keys.email, email)
    try json.set(Keys.phone, phone)
    return json
  }
}

// MARK: Relations
extension User {
  var clients: Children<User, Client> {
    return children()
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

extension User: ResponseRepresentable {}
