import Vapor
import Foundation
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
    if DateFormatter.mysql.date(from: parameter) != nil {
      return self.invalidQueryValueParameter
    }
    return parameter
  }
  
  static func storePastEvent() throws -> Identifier? {
    return try storeEvent(date: Date.randomValueInPast)
  }
  
  static func storeComingEvent() throws -> Identifier? {
    return try storeEvent(date: Date.randomValueInFuture)
  }
  
  static func storeEvent(date: Date = Date.randomValue) throws -> Identifier? {
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
      startDate: date.fiveHoursAgo,
      endDate: date,
      hide: Bool.randomValue
    )
    try event.save()
  
    return event.id
  }

  static func findEvent(by id: Identifier?) throws -> App.Event? {
    return try Event.makeQuery().find(id)
  }
}
