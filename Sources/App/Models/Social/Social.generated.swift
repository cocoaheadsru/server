// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider


extension Social {
  static var entity: String = "social"
}
extension Social {

  struct Keys {
    static let id = "id"
    static let name = "name"
    static let appId = "app_id"
    static let secureKey = "secure_key"
    static let serviceToken = "service_token"
  }
}

extension Social: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      name: try json.get(Keys.name),
      appId: try json.get(Keys.appId),
      secureKey: try json.get(Keys.secureKey),
      serviceToken: try json.get(Keys.serviceToken)
    )
  }
}

extension Social: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Keys.name)
      builder.string(Keys.appId)
      builder.string(Keys.secureKey)
      builder.string(Keys.serviceToken)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Social: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.name, name)
    try json.set(Keys.appId, appId)
    try json.set(Keys.secureKey, secureKey)
    try json.set(Keys.serviceToken, serviceToken)
    return json
  }
}
