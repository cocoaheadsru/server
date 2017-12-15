import Vapor
@testable import App

class EventHelper {
  
  static func cleanEventTable() throws {
    try Event.makeQuery().delete()
    try Place.makeQuery().delete()
    try City.makeQuery().delete()
  }
  
  static func storeEvent() throws -> Identifier? {
    let city = City(cityName: String.randomValue)
    try city.save()
    
    let place = Place(title: String.randomValue,
                      address: String.randomValue,
                      description: String.randomValue,
                      latitude: Double.randomValue,
                      longitude: Double.randomValue,
                      cityId: (city.id)!)
    try place.save()
    
    let event = Event(title: String.randomValue,
                      description: String.randomValue,
                      photoUrl: String.randomValue,
                      placeId: (place.id)!,
                      isRegistrationOpen: Bool.randomValue,
                      startDate: Int.randomValue,
                      endDate: Int.randomValue,
                      hide: Bool.randomValue)
    try event.save()
    
    return event.id
  }
  
  static func storeAndFetchEvent() throws -> App.Event? {
    let eventId = try storeEvent()
    let event = try findEvent(by: eventId)
    return event
  }
  
  static func findEvent(by id: Identifier?) throws -> App.Event? {
    return try Event.makeQuery().find(id)
  }
}
