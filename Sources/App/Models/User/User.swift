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


  /// The column names for `id` and `content` in the database
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

  // Serializes the Post to the database
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(User.Keys.id, id)
    return row
  }
}

// MARK: Fluent Preparation

extension User: Preparation {
  /// Prepares a table/collection in the database
  /// for storing Posts
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(User.Keys.name)
    }
  }

  /// Undoes what was done in `prepare`
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension User: JSONConvertible {
  convenience init(json: JSON) throws {
    self.init(
      name: try json.get(Post.Keys.name)
    )
  }

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Post.Keys.id, id)
    try json.set(Post.Keys.name, name)
    return json
  }
}

// MARK: HTTP

extension User: ResponseRepresentable { }

// MARK: Update

extension User: Updateable {

  public static var updateableKeys: [UpdateableKey<Post>] {
    return [
      UpdateableKey(User.Keys.name, String.self) { user, name in
        user.name = name
      }
    ]
  }
}

