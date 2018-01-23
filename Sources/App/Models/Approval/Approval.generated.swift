// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import FluentProvider

extension Approval {
  static var entity: String = "approval"
}

extension Approval {

  struct Keys {
    static let id = "id"
    static let visitedEvents = "visited_events"
    static let skippedEvents = "skipped_events"
    static let periodInMonths = "period_in_months"
  }
}

extension Approval: Updateable {

  public static var updateableKeys: [UpdateableKey<Approval>] {
    return [
      UpdateableKey(Keys.visitedEvents, Int.self) { $0.visitedEvents = $1 },
      UpdateableKey(Keys.skippedEvents, Int.self) { $0.skippedEvents = $1 },
      UpdateableKey(Keys.periodInMonths, Int.self) { $0.periodInMonths = $1 }
    ]
  }
}

extension Approval: JSONInitializable {

  convenience init(json: JSON) throws {
    self.init(
      visitedEvents: try json.get(Keys.visitedEvents),
      skippedEvents: try json.get(Keys.skippedEvents),
      periodInMonths: try json.get(Keys.periodInMonths)
    )
  }
}

extension Approval: Preparation {

  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.int(Keys.visitedEvents)
      builder.int(Keys.skippedEvents)
      builder.int(Keys.periodInMonths)
    }
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Approval: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.visitedEvents, visitedEvents)
    try json.set(Keys.skippedEvents, skippedEvents)
    try json.set(Keys.periodInMonths, periodInMonths)
    return json
  }
}
