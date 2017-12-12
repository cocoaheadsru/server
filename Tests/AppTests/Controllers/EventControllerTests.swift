import XCTest
import Testing
@testable import Vapor
@testable import App

class EventControllerTests: TestCase {
  let drop = try! Droplet.testable()
  let eventContoller = EventController()
  
  func testThatEventHasPlaceRelation() throws {
    try cleanEventTable()
    let eventId = try storeEvent()
    guard let event = try findEvent(by: eventId) else {
      XCTFail()
      return
    }
    
    let place = try event.place()
    XCTAssertNotNil(place)
  }
  
  func testThatGetEventByIdRouteReturnOkStatus() throws {
    try cleanEventTable()
    let eventId = try storeEvent()
    guard let id = eventId?.int else {
      XCTFail()
      return
    }
    
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event/\(id)")
      .assertStatus(is: .ok)
  }
}

extension EventControllerTests {
  
  fileprivate func cleanEventTable() throws {
    try Event.makeQuery().delete()
    try Place.makeQuery().delete()
    try City.makeQuery().delete()
  }
  
  fileprivate func storeEvent() throws -> Identifier? {
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
  
  func findEvent(by id: Identifier?) throws -> App.Event? {
    return try Event.makeQuery().find(id)
  }
}
