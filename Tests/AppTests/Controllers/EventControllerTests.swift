import XCTest
import Testing
@testable import Vapor
@testable import App

class EventControllerTests: TestCase {
  let drop = try! Droplet.testable()
  let eventContoller = EventController()
  
  override func setUp() {
    super.setUp()
    try! cleanEventTable()
  }
  
  func testThatEventHasPlaceRelation() throws {
    let eventId = try storeEvent()
    guard let event = try findEvent(by: eventId) else {
      XCTFail()
      return
    }
    
    let place = try event.place()
    XCTAssertNotNil(place)
  }
  
  func testThatPlaceOfEventHasCityRelation() throws {
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
    let eventId = try storeEvent()
    guard let event = try findEvent(by: eventId) else {
      XCTFail()
      return
    }
    guard let place = try event.place() else {
      XCTFail()
      return
    }
    guard let city = try place.city() else {
      XCTFail()
      return
    }
    
    let request = Request.makeTest(method: .get)
    let res = try eventContoller.show(request, event: event).makeResponse()
    let json = res.json

    XCTAssertEqual(json?["id"]?.int, event.id?.int)
    XCTAssertEqual(json?["title"]?.string, event.title)
    XCTAssertEqual(json?["description"]?.string, event.description)
    XCTAssertEqual(json?["photo_url"]?.string, event.photoUrl)
    XCTAssertEqual(json?["is_registration_open"]?.bool, event.isRegistrationOpen)
    XCTAssertEqual(json?["start_date"]?.int, event.startDate)
    XCTAssertEqual(json?["end_date"]?.int, event.endDate)
    XCTAssertEqual(json?["hide"]?.bool, event.hide)
    
    let placeJSON = json?["place"]?.makeJSON()
    XCTAssertEqual(placeJSON?["id"]?.int, place.id?.int)
    XCTAssertEqual(placeJSON?["latitude"]?.double, place.latitude)
    XCTAssertEqual(placeJSON?["longitude"]?.double, place.longitude)
    XCTAssertEqual(placeJSON?["title"]?.string, place.title)
    XCTAssertEqual(placeJSON?["description"]?.string, place.description)
    XCTAssertEqual(placeJSON?["address"]?.string, place.address)

    let cityJSON = placeJSON?["city"]?.makeJSON()
    XCTAssertEqual(cityJSON?["id"]?.int, city.id?.int)
    XCTAssertEqual(cityJSON?["city_name"]?.string, city.cityName)
  }
  
  // MARK: Endpoint tests
  
  func testThatGetEventByIdRouteReturnsOkStatus() throws {
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
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event/\(Int.randomValue)")
      .assertStatus(is: .notFound)
  }
}

extension EventControllerTests {
  
  fileprivate func cleanEventTable() throws {
    try EventSpeechHelper.cleanSpeechTable()
    try EventHelper.cleanEventTable()
  }
  
  fileprivate func storeEvent() throws -> Identifier? {
    return try EventHelper.storeEvent()
  }
  
  fileprivate func findEvent(by id: Identifier?) throws -> App.Event? {
    return try EventHelper.findEvent(by: id)
  }
}
