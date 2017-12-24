import Vapor
@testable import App

final class RegFormHelper {
  
  /// get EventId
  static func store() throws -> Identifier? {
   
    var cityId: [Identifier] = []
    var placeId: [Identifier] = []
    var eventId: [Identifier] = []
    let iterations: (min: Int, max: Int) = (min: 1, max: Int.random(min: 2, max: 10))
   
    for _ in iterations.min...iterations.max {
      let city = City(cityName: String.randomValue)
      try city.save()
      cityId.append(city.id!)
    }
    
    for _ in iterations.min...iterations.max {
      let place = Place(
        title: String.randomValue,
        address: String.randomValue,
        description: String.randomValue,
        latitude: Double.randomValue,
        longitude: Double.randomValue,
        cityId: cityId.randomValue)
      try place.save()
      placeId.append(place.id!)
    }
    
    for _ in iterations.min...iterations.max {
      let event = Event(
        title: String.randomValue,
        description: String.randomValue,
        photoUrl: String.randomValue,
        placeId: placeId.randomValue,
        startDate: Int.randomValue,
        endDate: Int.randomValue)
      try event.save()
      eventId.append(event.id!)
    }
    
    let shuflleEventId = eventId.shuffled()
    for i in iterations.min...iterations.max {
      let regForm = RegForm(
        eventId: shuflleEventId[i-1],
        formName: String.randomValue,
        description: String.randomValue)
      try regForm.save()
    }
  
    return eventId.randomValue
  }
  
  static func fetchRegFormByEventId(_ eventId: Identifier) throws  -> RegForm? {
    return try RegForm.makeQuery().filter("event_id", eventId).first()
  }
  
}
