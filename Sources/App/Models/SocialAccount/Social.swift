import Vapor
import FluentProvider
import HTTP

final class Social: Model {
  let storage = Storage()
  
  var name: String
  var appId: String
  var secureKey: String
  var serviceToken: String
  
  struct Keys {
    static let id = "id"
    static let name  = "name"
    static let appId = "app_id"
    static let secureKey = "secure_key"
    static let serviceToken = "service_token"
  }
  
  init(name: String, appId: String, secureKey: String, serviceToken: String) {
    self.name = name
    self.appId = appId
    self.secureKey = secureKey
    self.serviceToken = serviceToken
  }
  
  init(row: Row) throws {
    name = try row.get(Social.Keys.name)
    appId = try row.get(Social.Keys.appId)
    secureKey = try row.get(Social.Keys.secureKey)
    serviceToken = try row.get(Social.Keys.serviceToken)
    id = try row.get(Social.Keys.id)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Social.Keys.id, id)
    try row.set(Social.Keys.name, name)
    try row.set(Social.Keys.appId, appId)
    try row.set(Social.Keys.secureKey, secureKey)
    try row.set(Social.Keys.serviceToken, serviceToken)
    return row
  }
}

// MARK: Relations

extension Social {
  var accounts: Children<Social, SocialAccount> {
    return children()
  }
}

// MARK: Fluent Preparation

extension Social: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Social.Keys.name)
      builder.string(Social.Keys.appId)
      builder.string(Social.Keys.secureKey)
      builder.string(Social.Keys.serviceToken)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension Social: JSONConvertible {
  convenience init(json: JSON) throws {
    try self.init(
      name: json.get(Social.Keys.name),
      appId: json.get(Social.Keys.appId),
      secureKey: json.get(Social.Keys.secureKey),
      serviceToken: json.get(Social.Keys.serviceToken))
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Social.Keys.id, id)
    try json.set(Social.Keys.name, name)
    try json.set(Social.Keys.appId, appId)
    try json.set(Social.Keys.secureKey, secureKey)
    try json.set(Social.Keys.serviceToken, serviceToken)
    return json
  }
}

