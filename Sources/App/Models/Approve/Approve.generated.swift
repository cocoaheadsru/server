// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Approve {
  static var entity: String = "approve"
}

extension Approve {

  struct Keys {
    static let id = "id"
    static let visits = "visits"
    static let notAppears = "not_appears"
    static let appearMonths = "appear_months"
  }
}

extension Approve: Updateable {

  public static var updateableKeys: [UpdateableKey<Approve>] {
    return [
      UpdateableKey(Keys.visits, Int.self) { $0.visits = $1 },
      UpdateableKey(Keys.notAppears, Int.self) { $0.notAppears = $1 },
      UpdateableKey(Keys.appearMonths, Int.self) { $0.appearMonths = $1 }
    ]
  }
}

extension Approve: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      visits: try json.get(Keys.visits),
      notAppears: try json.get(Keys.notAppears),
      appearMonths: try json.get(Keys.appearMonths)
    )
  }
}

extension Approve: Preparation {

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

extension Approve: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.visits, visits)
    try json.set(Keys.notAppears, notAppears)
    try json.set(Keys.appearMonths, appearMonths)
    return json
  }
}
