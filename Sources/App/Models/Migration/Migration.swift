import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: fromJSON, toJSON, Preparation
final class Migration: Model {
    
  let storage = Storage()
  
  var version: String
  var applyTime: Int?
  
  init(version: String, applyTime: Int?) {
    self.version = version
    self.applyTime = applyTime
  }
  
  // sourcery:inline:auto:Migration.AutoModelGeneratable
  init(row: Row) throws {
    version = try row.get(Keys.version)
    applyTime = try row.get(Keys.applyTime)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.version, version)
    try row.set(Keys.applyTime, applyTime)
    return row
  }
  // sourcery:end
}
