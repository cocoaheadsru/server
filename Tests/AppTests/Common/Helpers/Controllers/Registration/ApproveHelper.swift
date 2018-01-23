import Vapor
import Foundation
@testable import App

typealias ApproveRules = (visitedEvents: Int, skippedEvents: Int, periodInMonths: Int)

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class ApproveHelper {
  
  @discardableResult
  static func store(places: [Place] = [], cities: [City] = []) throws -> [App.Event]? {
    
    var cityIds: [Identifier] = []
    var placeIds: [Identifier] = []
    var events = [App.Event]()
    let randomRange = 1...Int.random(min: 10, max: 20)
    let months = 24
    
    if cities.count == 0 {
      for _ in randomRange {
        let city = City()
        try! city.save()
        cityIds.append(city.id!)
      }
    } else {
      cityIds =  cities.map { city in city.id! }
    }
    
    if places.isEmpty {
      for _ in randomRange {
        let place = Place(true, cityId: cityIds.randomValue)
        try! place.save()
        placeIds.append(place.id!)
      }
    } else {
      placeIds = places.map { place in place.id!}
    }
    
    for i in 0...months-1 {
      
      guard
        let date = Calendar.current.date(byAdding: .month, value: -i, to: Date()),
        let date1 = Calendar.current.date(byAdding: .day, value: -6, to: date),
        let date2 = Calendar.current.date(byAdding: .day, value: -12, to: date)
        else {
          return nil
      }
      
      let event1 = App.Event(endDate: date1, placeId: placeIds.randomValue)
      let event2 = App.Event(endDate: date2, placeId: placeIds.randomValue)
      
      try! event1.save()
      try! event2.save()
      
      events.append(event1)
      events.append(event2)
    }
    
    return events
  }
  
}
