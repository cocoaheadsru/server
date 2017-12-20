import Vapor
@testable import App

class EventHelper {
  
  static var invalidQueryKeyParameter: String {
    let parameter = String.randomValue
    if ["before", "after"].contains(parameter) {
      return self.invalidQueryKeyParameter
    }
    return parameter
  }
  
  static var invalidQueryValueParameter: String {
    let parameter = String.randomValue
    if parameter.int != nil {
      return self.invalidQueryValueParameter
    }
    return parameter
  }
  
  static func cleanEventTable() throws {
    try Event.makeQuery().delete()
    try Place.makeQuery().delete()
    try City.makeQuery().delete()
  }
  
  static func storeEvent(before timestamp: Int) throws -> Identifier? {
    let t = Int.random(min: 5000, max: timestamp - 1)
    return try storeEvent(timestamp: t)
  }
  
  static func storeEvent(after timestamp: Int) throws -> Identifier? {
    let t = Int.random(min: timestamp + 1, max: timestamp * 2)
    return try storeEvent(timestamp: t)
  }
  
  static func storeEvent(timestamp: Int = Int.randomTimestamp) throws -> Identifier? {
    let city = City(
      cityName: String.randomValue
    )
    try city.save()
    
    let place = Place(
      title: String.randomValue,
      address: String.randomValue,
      description: String.randomValue,
      latitude: Double.randomValue,
      longitude: Double.randomValue,
      cityId: (city.id)!
    )
    try place.save()
    
    let event = Event(
      title: String.randomValue,
      description: String.randomValue,
      photoUrl: String.randomValue,
      placeId: (place.id)!,
      isRegistrationOpen: Bool.randomValue,
      startDate: timestamp - 5000,
      endDate: timestamp,
      hide: Bool.randomValue
    )
    try event.save()
  
    return event.id
  }

  static func findEvent(by id: Identifier?) throws -> App.Event? {
    return try Event.makeQuery().find(id)
  }
}
