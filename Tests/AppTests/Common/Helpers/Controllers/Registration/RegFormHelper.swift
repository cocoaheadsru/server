import Vapor
@testable import App

typealias  EventId = Identifier

final class RegFormHelper {
  
  /// get EventId
  static func store() throws -> App.Event? {
   
    var cityId: [Identifier] = []
    var placeId: [Identifier] = []
    var eventId: [Identifier] = []
    let iterations: (min: Int, max: Int) = (min: 1, max: Int.random(min: 2, max: 10))
   
    for _ in iterations.min...iterations.max {
      let city = City()
      try city.save()
      cityId.append(city.id!)
    }
    
    for _ in iterations.min...iterations.max {
      let place = Place(true, cityId: cityId.randomValue)
      try place.save()
      placeId.append(place.id!)
    }
    
    for _ in iterations.min...iterations.max {
      let event = Event(placeId: placeId.randomValue)
      try event.save()
      eventId.append(event.id!)
    }
    
    let shuflleEventId = eventId.shuffled()
    for i in iterations.min...iterations.max {
      let regForm = RegForm(eventId: shuflleEventId[i-1])
      try regForm.save()
    }
  
    return try App.Event.find(eventId.randomValue)
  }
  
  static func fetchRegFormByEventId(_ eventId: Identifier) throws  -> RegForm? {
    return try RegForm.makeQuery().filter("event_id", eventId).first()
  }
  
}
