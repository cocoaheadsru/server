import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, fromJSON, Updateable
final class Approve: Model {
  
  let storage = Storage()
  
  var visits: Int
  var notAppears: Int
  var appearMonths: Int
  
  init(visits: Int = 2, notAppears: Int = 2, appearMonths: Int = 6) {
    self.visits = visits
    self.notAppears = notAppears
    self.appearMonths = appearMonths
  }
  
// sourcery:inline:auto:Approve.AutoModelGeneratable
  init(row: Row) throws {
    visits = try row.get(Keys.visits)
    notAppears = try row.get(Keys.notAppears)
    appearMonths = try row.get(Keys.appearMonths)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.visits, visits)
    try row.set(Keys.notAppears, notAppears)
    try row.set(Keys.appearMonths, appearMonths)
    return row
  }
// sourcery:end
}
