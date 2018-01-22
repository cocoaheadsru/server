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
    static let visitedEvents = "visited_events"
    static let skippedEvents = "skipped_events"
    static let forPeriodInMonths = "for_period_in_months"
  }
}

extension Approve: Updateable {

  public static var updateableKeys: [UpdateableKey<Approve>] {
    return [
      UpdateableKey(Keys.visitedEvents, Int.self) { $0.visitedEvents = $1 },
      UpdateableKey(Keys.skippedEvents, Int.self) { $0.skippedEvents = $1 },
      UpdateableKey(Keys.forPeriodInMonths, Int.self) { $0.forPeriodInMonths = $1 }
    ]
  }
}

extension Approve: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      visitedEvents: try json.get(Keys.visitedEvents),
      skippedEvents: try json.get(Keys.skippedEvents),
      forPeriodInMonths: try json.get(Keys.forPeriodInMonths)
    )
  }
}

extension Approve: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.int(Keys.visitedEvents)
      builder.int(Keys.skippedEvents)
      builder.int(Keys.forPeriodInMonths)
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
    try json.set(Keys.visitedEvents, visitedEvents)
    try json.set(Keys.skippedEvents, skippedEvents)
    try json.set(Keys.forPeriodInMonths, forPeriodInMonths)
    return json
  }
}
