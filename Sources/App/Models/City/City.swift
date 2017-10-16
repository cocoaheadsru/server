import Vapor
import FluentProvider

final class City: Model {
  
  let storage = Storage()
  
  var cityName: String
  
  struct Keys {
    static let id = "id"
    static let cityName = "city_name"
  }
  
  init(cityName: String) {
    self.cityName = cityName
  }
  
  // MARK: Fluent Serialization
  
  init(row: Row) throws {
    cityName = try row.get(City.Keys.cityName)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(City.Keys.cityName, cityName)
    return row
  }
}

// MARK: Fluent Preparation

extension City: Preparation {
  
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(City.Keys.cityName)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

extension City: JSONRepresentable {
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(City.Keys.id, id)
    try json.set(City.Keys.cityName, cityName)
    return json
  }
}

// MARK: HTTP

extension City: ResponseRepresentable { }
