// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Autoapprove {
  static var entity: String = "autoapprove"
}

extension Autoapprove {

  struct Keys {
    static let id = "id"
    static let visits = "visits"
    static let notAppears = "not_appears"
    static let appearMonths = "appear_months"
  }
}

extension Autoapprove: Updateable {

  public static var updateableKeys: [UpdateableKey<Autoapprove>] {
    return [
      UpdateableKey(Keys.visits, Int.self) { $0.visits = $1 },
      UpdateableKey(Keys.notAppears, Int.self) { $0.notAppears = $1 },
      UpdateableKey(Keys.appearMonths, Int.self) { $0.appearMonths = $1 }
    ]
  }
}

extension Autoapprove: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      visits: try json.get(Keys.visits),
      notAppears: try json.get(Keys.notAppears),
      appearMonths: try json.get(Keys.appearMonths)
    )
  }
}

extension Autoapprove: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.int(Keys.visits)
      builder.int(Keys.notAppears)
      builder.int(Keys.appearMonths)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Autoapprove: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.visits, visits)
    try json.set(Keys.notAppears, notAppears)
    try json.set(Keys.appearMonths, appearMonths)
    return json
  }
}
