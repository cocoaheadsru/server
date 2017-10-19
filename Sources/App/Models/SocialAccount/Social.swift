import Vapor
import FluentProvider
import HTTP

final class Social: Model {
  let storage = Storage()
  
  var socialId: Int
  var name: String
  var appId: String
  var secureKey: String
  var serviceToken: String
  
  struct Keys {
    static let socialId = "social_id"
    static let name  = "name"
    static let appId = "app_id"
    static let secureKey = "secure_key"
    static let serviceToken = "service_token"
  }
  
  init(socialId: Int, name: String, appId: String, secureKey: String, serviceToken: String) {
    self.socialId = socialId
    self.name = name
    self.appId = appId
    self.secureKey = secureKey
    self.serviceToken = serviceToken
  }
  
  init(row: Row) throws {
    socialId = try row.get(Social.Keys.socialId)
    name = try row.get(Social.Keys.name)
    appId = try row.get(Social.Keys.appId)
    secureKey = try row.get(Social.Keys.secureKey)
    serviceToken = try row.get(Social.Keys.serviceToken)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Social.Keys.socialId, socialId)
    try row.set(Social.Keys.name, name)
    try row.set(Social.Keys.appId, appId)
    try row.set(Social.Keys.secureKey, secureKey)
    try row.set(Social.Keys.serviceToken, serviceToken)
    return row
  }
}

extension Social {
  var accounts: Children<Social, SocialAccount> {
    return children()
  }
}

extension Social: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Social.Keys.socialId)
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

extension Social: JSONConvertible {
  convenience init(json: JSON) throws {
    try self.init(
      socialId: json.get(Social.Keys.socialId),
      name: json.get(Social.Keys.name),
      appId: json.get(Social.Keys.appId),
      secureKey: json.get(Social.Keys.secureKey),
      serviceToken: json.get(Social.Keys.serviceToken))
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Social.Keys.socialId, socialId)
    try json.set(Social.Keys.name, name)
    try json.set(Social.Keys.appId, appId)
    try json.set(Social.Keys.secureKey, secureKey)
    try json.set(Social.Keys.serviceToken, serviceToken)
    return json
  }
}

