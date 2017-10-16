import Vapor
import FluentProvider

final class RegField: Model {
  
  let storage = Storage()
  
  struct Keys {
    static let id = "id"
  }
  
  // MARK: Fluent Serialization
  
  init(row: Row) throws {
    //
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    return row
  }
}
