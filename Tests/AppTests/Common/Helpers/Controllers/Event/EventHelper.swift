import Vapor
import Foundation
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
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
    return try! storeEvent(date: Date.randomValueInFuture)
  }
  
  static func storeEvent(date: Date = Date.randomValue) throws -> Identifier? {
    let city = City()
    try! city.save()
    
    let place = Place(cityId: city.id!)
    try! place.save()
    
    let event = App.Event(endDate: date, placeId: place.id!)
    try! event.save()
  
    return event.id
  }

  static func findEvent(by id: Identifier?) throws -> App.Event? {
    return try! Event.find(id)
  }
}
