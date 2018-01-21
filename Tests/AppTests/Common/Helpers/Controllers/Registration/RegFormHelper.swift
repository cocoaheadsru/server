import Vapor
@testable import App

typealias  EventId = Identifier

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class RegFormHelper {
  
  static func assertRegFromHasExpectedFields(_ regForm: JSON) throws -> Bool {
    guard
      let _ = regForm["id"]?.int,
      let _ = regForm["form_name"]?.string,
      let _ = regForm["description"]?.string,
      let _ = regForm["reg_fields"]?.makeJSON()
      else {
        return false
    }
    return true
  }
  
  @discardableResult
  static func store(for events: [App.Event] = []) throws -> [RegForm]? {
    var regForms = [RegForm]()
    if events.count == 0 {
      var cityId: [Identifier] = []
      var placeId: [Identifier] = []
      var eventId: [Identifier] = []
      let iterations: (min: Int, max: Int) = (min: 1, max: Int.random(min: 10, max: 20))
      
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
        try! event.save()
        eventId.append(event.id!)
      }
      
      let shuflleEventId = eventId.shuffled()
      for i in iterations.min...iterations.max {
        let regForm = RegForm(eventId: shuflleEventId[i-1])
        try regForm.save()
        regForms.append(regForm)
      }
    } else {
      
      for event in events {
        let regForm = RegForm(eventId: event.id!)
        try regForm.save()
        regForms.append(regForm)
      }
      
    }
    return regForms
  }
  
}
