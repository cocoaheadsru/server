import XCTest
import Testing
@testable import Vapor
@testable import App

class EventControllerTests: TestCase {
  let droplet = try! Droplet.testable()
  let eventContoller = EventController()
  
  func testThatEventHasPlaceRelation() throws {
    try cleanEventTable()
    let eventId = try storeEvent()
    let event = try Event.makeQuery().find(eventId)
    guard event = event else { XCTFail() }
    
    let place = try event.place()
    XCTAssertNotNil(place)
  }
  
  func testThatEventHasSpeechesRelation() throws {
    try cleanEventTable()
    let eventId = try storeEvent()
    try storeSpeeches(forEventId: eventId)
    
    let event = try Event.makeQuery().find(eventId)
    guard event = event else { XCTFail() }
    
    let speeches = event.speeches()
    XCTAssertEqual(speeches.count, 3)
  }
  
//  func testThatFetchingEventByIdPasses() throws {
//    try cleanEventTable()
//    let dummyEvent = try storeEvent()
//
//    eventController.show(id: dummyEvent.id)
//  }
}

extension EventControllerTests {
  
  fileprivate func cleanEventTable() throws {
    try Event.makeQuery().delete()
    try Place.makeQuery().delete()
    try City.makeQuery().delete()
  }
  
  fileprivate func storeSpeeches(forEventId eventId: Identifier?) throws {
    //
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
}
