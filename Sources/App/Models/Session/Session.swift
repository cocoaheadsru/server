import Vapor
import FluentProvider
import Foundation
import Crypto

// sourcery: AutoModelGeneratable
// sourcery: Preparation, Timestampable
final class Session: Model {
    
  let storage = Storage()
  
  // sourcery: unique = true
  var userId: Identifier
  var token: String
  var actual: Bool
  
  init(userId: Identifier,
       token: String,
       actual: Bool = true) {
    self.userId = userId
    self.token = token
    self.actual = actual
  }

  // sourcery:inline:auto:Session.AutoModelGeneratable
  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    token = try row.get(Keys.token)
    actual = try row.get(Keys.actual)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.token, token)
    try row.set(Keys.actual, actual)
    return row
  }
  // sourcery:end
}

extension Session: JSONRepresentable {
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.token, token)
    try json.set(Keys.actual, actual)
    return json
  }
}

extension Session {

  static func find(by token: String) throws -> Session? {
    return try Session.makeQuery().filter(Keys.token, token).first()
  }

  var user: User? {
    return try? parent(id: userId).get()!
  }
  
  static func generateToken() throws -> String {
    let random = try Crypto.Random.bytes(count: 16)
    return random.base64Encoded.makeString()
  }
  
  func updateToken() throws {
    if
      let date = updatedAt,
      let referenceDate = Calendar.current.date(byAdding: .month, value: 1, to: date),
      referenceDate < Date() {
      self.token = try Session.generateToken()
      try self.save()
    }
  }
}
