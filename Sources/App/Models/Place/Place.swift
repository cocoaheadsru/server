import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Place: Model {
  
  static var entity: String = "place"
  
  let storage = Storage()
  
  // sourcery: relatedModel = City
  var cityId: Identifier
  var title: String
  var address: String
  var description: String
  var latitude: Double
  var longitude: Double
  
  init(title: String, address: String, description: String, latitude: Double, longitude: Double, cityId: Identifier) {
    self.title = title
    self.address = address
    self.description = description
    self.latitude = latitude
    self.longitude = longitude
    self.cityId = cityId
  }
  
  // sourcery:inline:auto:Place.AutoModelGeneratable

  init(row: Row) throws {
    cityId = try row.get(Keys.cityId)
    title = try row.get(Keys.title)
    address = try row.get(Keys.address)
    description = try row.get(Keys.description)
    latitude = try row.get(Keys.latitude)
    longitude = try row.get(Keys.longitude)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.cityId, cityId)
    try row.set(Keys.title, title)
    try row.set(Keys.address, address)
    try row.set(Keys.description, description)
    try row.set(Keys.latitude, latitude)
    try row.set(Keys.longitude, longitude)
    return row
  }
  // sourcery:end
}

extension Place {
  
  func city() throws -> City? {
    return try children().first()
  }
}
