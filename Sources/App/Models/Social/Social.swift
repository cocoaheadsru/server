import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation
final class Social: Model {
  
  let storage = Storage()
  // sourcery: unique
  var name: String
  var appId: String?
  var secureKey: String?
  var serviceToken: String?
  
  init(name: String,
       appId: String? = nil,
       secureKey: String? = nil,
       serviceToken: String? = nil) {
    self.name = name
    self.appId = appId
    self.secureKey = secureKey
    self.serviceToken = serviceToken
  }
  
  // sourcery:inline:auto:Social.AutoModelGeneratable
  init(row: Row) throws {
    name = try row.get(Keys.name)
    appId = try? row.get(Keys.appId)
    secureKey = try? row.get(Keys.secureKey)
    serviceToken = try? row.get(Keys.serviceToken)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.name, name)
    try? row.set(Keys.appId, appId)
    try? row.set(Keys.secureKey, secureKey)
    try? row.set(Keys.serviceToken, serviceToken)
    return row
  }
  // sourcery:end
}

extension Social {

  static func find(by name: String) throws -> Social? {
    return try Social
      .makeQuery()
      .filter(Keys.name, name)
      .first()
  }
}

extension Social {
  struct Nets {
    static let fb = "facebook"
    static let vk = "vkontakte"
    static let git = "github"
  }
}
