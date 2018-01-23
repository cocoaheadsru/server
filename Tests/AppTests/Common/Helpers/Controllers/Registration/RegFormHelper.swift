import Vapor
@testable import App

typealias  EventId = Identifier

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class RegFormHelper {
  
  static func assertRegFromHasExpectedFields(_ regForm: JSON) throws -> Bool {
    return
      regForm["id"]?.int != nil &&
      regForm["form_name"]?.string != nil &&
      regForm["description"]?.string != nil &&
      regForm["reg_fields"]?.makeJSON() != nil
  }
  
  @discardableResult
  static func store(for events: [App.Event] = []) throws -> [RegForm]? {
    var regForms: [RegForm] = []
    if events.isEmpty {
      var cityIds: [Identifier] = []
      var placeIds: [Identifier] = []
      var eventIds: [Identifier] = []
      let randomRange = 1...Int.random(min: 10, max: 20)
      
      for _ in randomRange {
        let city = City()
        try city.save()
        cityIds.append(city.id!)
      }
      
      for _ in randomRange {
        let place = Place(true, cityId: cityIds.randomValue)
        try place.save()
        placeIds.append(place.id!)
      }
      
      for _ in randomRange {
        let event = Event(placeId: placeIds.randomValue)
        try! event.save()
        eventIds.append(event.id!)
      }
      
      let shuflleEventId = eventIds.shuffled()
      for i in randomRange {
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
