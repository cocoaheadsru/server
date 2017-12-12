// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension User {
  static var entity: String = "user"
}

extension User {

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
}

extension User: ResponseRepresentable { }

extension User: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      name: try json.get(Keys.name),
      lastname: try json.get(Keys.lastname),
      company: try json.get(Keys.company),
      position: try json.get(Keys.position),
      photo: try json.get(Keys.photo),
      email: try json.get(Keys.email),
      phone: try json.get(Keys.phone)
    )
  }
}

extension User: Timestampable { }

extension User: Updateable {

  public static var updateableKeys: [UpdateableKey<User>] {
    return [
      UpdateableKey(Keys.name, String.self) { $0.name = $1 },
      UpdateableKey(Keys.lastname, String.self) { $0.lastname = $1 },
      UpdateableKey(Keys.company, String.self) { $0.company = $1 },
      UpdateableKey(Keys.position, String.self) { $0.position = $1 },
      UpdateableKey(Keys.photo, String.self) { $0.photo = $1 },
      UpdateableKey(Keys.email, String.self) { $0.email = $1 },
      UpdateableKey(Keys.phone, String.self) { $0.phone = $1 }
    ]
  }
}

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

extension User: JSONRepresentable {

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
