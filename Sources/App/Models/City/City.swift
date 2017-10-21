import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class City: Model {
  
  static var entity: String = "city"
  
  let storage = Storage()
  
  var cityName: String
  
  init(cityName: String) {
    self.cityName = cityName
  }
  
  // sourcery:inline:auto:City.AutoModelGeneratable
  init(row: Row) throws {
    cityName = try row.get(Keys.cityName)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.cityName, cityName)
    return row
  }
  // sourcery:end
}
