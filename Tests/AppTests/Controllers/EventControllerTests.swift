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
  
  func testThatPlaceOfEventHasCityRelation() throws {
    try cleanEventTable()
    let eventId = try storeEvent()
    guard let event = try findEvent(by: eventId) else {
      XCTFail()
      return
    }
    
    let place = try event.place()
    let city = try place?.city()
    XCTAssertNotNil(city)
  }
  
  func testThatShowEventReturnsOkStatus() throws {
    try cleanEventTable()
    let eventId = try storeEvent()
    guard let event = try findEvent(by: eventId) else {
      XCTFail()
      return
    }
    
    let request = Request.makeTest(method: .get)
    let res = try eventContoller.show(request, event: event).makeResponse()
    XCTAssertEqual(res.status, .ok)
  }
  
  func testThatShowEventReturnsJSONWithAllRequiredFields() throws {
    try cleanEventTable()
    let eventId = try storeEvent()
    guard let event = try findEvent(by: eventId) else {
      XCTFail()
      return
    }
    
    let request = Request.makeTest(method: .get)
    let res = try eventContoller.show(request, event: event).makeResponse()
    let json = res.json
    
    XCTAssertNotNil(json)
    XCTAssertNotNil(json?["id"])
    XCTAssertNotNil(json?["title"])
    XCTAssertNotNil(json?["description"])
    XCTAssertNotNil(json?["photo_url"])
    XCTAssertNotNil(json?["is_registration_open"])
    XCTAssertNotNil(json?["start_date"])
    XCTAssertNotNil(json?["end_date"])
    XCTAssertNotNil(json?["hide"])
    XCTAssertNotNil(json?["place"])
    
    let placeJSON = json?["place"]?.makeJSON()
    XCTAssertNotNil(placeJSON?["id"])
    XCTAssertNotNil(placeJSON?["latitude"])
    XCTAssertNotNil(placeJSON?["longitude"])
    XCTAssertNotNil(placeJSON?["title"])
    XCTAssertNotNil(placeJSON?["description"])
    XCTAssertNotNil(placeJSON?["address"])
    XCTAssertNotNil(placeJSON?["city"])
    
    let cityJSON = placeJSON?["city"]?.makeJSON()
    XCTAssertNotNil(cityJSON?["id"])
    XCTAssertNotNil(cityJSON?["city_name"])
  }
  
  func testThatShowEventReturnsJSONWithExpectedFields() throws {
    try cleanEventTable()
    let eventId = try storeEvent()
    guard let event = try findEvent(by: eventId) else {
      XCTFail()
      return
    }
    
    let request = Request.makeTest(method: .get)
    let res = try eventContoller.show(request, event: event).makeResponse()
    let json = res.json
    let expectedPlaceJSON = try event.place()?.makeJSON()
    let expectedCityJSON = try event.place()?.city()?.makeJSON()

    XCTAssertEqual(json?["id"]?.int, event.id?.int)
    XCTAssertEqual(json?["place"]?.makeJSON(), expectedPlaceJSON)
    XCTAssertEqual(json?["place"]?.makeJSON()["city"]?.makeJSON(), expectedCityJSON)
    XCTAssertEqual(json?["title"]?.string, event.title)
    XCTAssertEqual(json?["description"]?.string, event.description)
    XCTAssertEqual(json?["photo_url"]?.string, event.photoUrl)
    XCTAssertEqual(json?["is_registration_open"]?.bool, event.isRegistrationOpen)
    XCTAssertEqual(json?["start_date"]?.int, event.startDate)
    XCTAssertEqual(json?["end_date"]?.int, event.endDate)
    XCTAssertEqual(json?["hide"]?.bool, event.hide)
  }
  
  // MARK: Endpoint tests
  
  func testThatGetEventByIdRouteReturnsOkStatus() throws {
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
  
  func testThatGetEventByIdRouteFailsForEmptyTable() throws {
    try cleanEventTable()
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event/\(Int.randomValue)")
      .assertStatus(is: .notFound)
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
