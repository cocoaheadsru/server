import XCTest
import Testing
@testable import Vapor
@testable import App
//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try

class EventControllerTests: TestCase {
  
  let eventContoller = EventController()

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }
  
  func testThatEventHasPlaceRelation() throws {
    let eventId = try! storeEvent()
    let event = try! findEvent(by: eventId)
    let place = try! event?.place()
    XCTAssertNotNil(place)
  }
  
  func testThatPlaceOfEventHasCityRelation() throws {
    let eventId = try! storeEvent()
    let event = try! findEvent(by: eventId)
    let place = try! event?.place()
    let city = try! place?.city()
    XCTAssertNotNil(city)
  }
  
  func testThatIndexEventsReturnsOkStatusForBeforeQueryKey() throws {
    let query = "before=\(Date.randomValue.mysqlString)"
    let request = Request.makeTest(method: .get, query: query)
    let res = try! eventContoller.index(request).makeResponse()
    XCTAssertEqual(res.status, .ok)
  }
  
  func testThatIndexEventsReturnsOkStatusForAfterQueryKey() throws {
    let query = "after=\(Date.randomValue.mysqlString)"
    let request = Request.makeTest(method: .get, query: query)
    let res = try! eventContoller.index(request).makeResponse()
    XCTAssertEqual(res.status, .ok)
  }
  
  func testThatIndexEventsReturnsJSONArray() throws {
    let resAfter = try! fetchPastEvents()
    let resBefore = try! fetchComingEvents()
    XCTAssertNotNil(resAfter.json?.array)
    XCTAssertNotNil(resBefore.json?.array)
  }
  
  func testThatIndexEventsReturnsJSONArrayEventsHasAllRequiredFields() throws {
    try storeComingEvent()
    try storePastEvent()

    let resAfter = try! fetchComingEvents()
    let resBefore = try! fetchPastEvents()
    
    let eventJSON1 = resAfter.json?.array?.first
    let eventJSON2 = resBefore.json?.array?.first
    
    assertEventHasRequiredFields(json: eventJSON1)
    assertEventHasRequiredFields(json: eventJSON2)
  }
  
  func testThatIndexEventsReturnsJSONArrayEventsHasAllExpectedFields() throws {
    let eventId1 = try! storeComingEvent()
    let eventId2 = try! storePastEvent()
    
    guard
      let event1 = try! findEvent(by: eventId1),
      let event2 = try! findEvent(by: eventId2)
    else {
      XCTFail("Can't get event")
      return
    }
    
    let resAfter = try! fetchComingEvents()
    let resBefore = try! fetchPastEvents()
    
    let eventJSON1 = resAfter.json?.array?.first
    let eventJSON2 = resBefore.json?.array?.first
    
    try assertEventHasExpectedFields(json: eventJSON1, event: event1)
    try assertEventHasExpectedFields(json: eventJSON2, event: event2)
  }
  
  func testThatIndexEventsReturnsCorrectNumberOfPastEvents() throws {
    let expectedEventsCount = Int.random(min: 1, max: 20)
    try storePastEvents(count: expectedEventsCount)
    
    let res = try fetchPastEvents()
    let actualEventsCount = res.json?.array?.count
    XCTAssertEqual(actualEventsCount, expectedEventsCount)
  }
  
  func testThatIndexEventsReturnsCorrectNumberOfComingEvents() throws {
    let expectedEventsCount = Int.random(min: 1, max: 20)
    try storeComingEvents(count: expectedEventsCount)
    
    let res = try fetchComingEvents()
    let actualEventsCount = res.json?.array?.count
    XCTAssertEqual(actualEventsCount, expectedEventsCount)
  }
  
  func testThatIndexEventsReturnsCorrectNumberOfPastAndComingEvents() throws {
    let expectedPastEventsCount = Int.random(min: 1, max: 20)
    let expectedComingEventsCount = Int.random(min: 1, max: 20)
    
    try! storePastEvents(count: expectedPastEventsCount)
    try! storeComingEvents(count: expectedComingEventsCount)
    
    let resBefore = try! fetchPastEvents()
    let resAfter = try! fetchComingEvents()

    let actualPastEventsCount = resBefore.json?.array?.count
    let actualComingEventsCount = resAfter.json?.array?.count
    XCTAssertEqual(actualPastEventsCount, expectedPastEventsCount)
    XCTAssertEqual(actualComingEventsCount, expectedComingEventsCount)
  }
  
  // MARK: Endpoint tests
    
  func testThatGetEventsBeforeTimestampRouteReturnsOkStatus() throws {
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event", query: "before=\(Date.randomValue.mysqlString)")
      .assertStatus(is: .ok)
  }
  
  func testThatGetEventsAfterTimestampRouteReturnsOkStatus() throws {
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event", query: "after=\(Date.randomValue.mysqlString)")
      .assertStatus(is: .ok)
  }
  
  func testThatGetEventsRouteFailsForEmptyQueryParameters() throws {
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event")
      .assertStatus(is: .badRequest)
  }
  
  func testThatGetEventsRouteFailsWithWrongQueryParameterKey() throws {
    let query = "\(EventHelper.invalidQueryKeyParameter)=\(Date.randomValue.mysqlString)"
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event", query: query)
      .assertStatus(is: .badRequest)
  }
  
  func testThatGetEventsRouteFailsWithWrongQueryParameterValue() throws {
    let validKey = Bool.randomValue ? "after" : "before"
    let query = "\(validKey)=\(EventHelper.invalidQueryValueParameter)"
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "event", query: query)
      .assertStatus(is: .badRequest)
  }
}

fileprivate extension EventControllerTests {
  
  func assertEventHasRequiredFields(json: JSON?) {
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
    XCTAssertNotNil(json?["status"])
    XCTAssertNotNil(json?["speakers_photos"])

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
  
  func assertEventHasExpectedFields(json: JSON?, event: App.Event) throws {
    guard let place = try! event.place() else {
      XCTFail("Can't get place")
      return
    }
    guard let city = try! place.city() else {
      XCTFail("Can't get city")
      return
    }
    
    XCTAssertEqual(json?["id"]?.int, event.id?.int)
    XCTAssertEqual(json?["title"]?.string, event.title)
    XCTAssertEqual(json?["description"]?.string, event.description)
    XCTAssertEqual(json?["photo_url"]?.string, event.photoUrl)
    XCTAssertEqual(json?["is_registration_open"]?.bool, event.isRegistrationOpen)
    XCTAssertEqual(json?["start_date"]?.string, event.startDate.mysqlString)
    XCTAssertEqual(json?["end_date"]?.string, event.endDate.mysqlString)
    XCTAssertEqual(json?["hide"]?.bool, event.hide)
    XCTAssertEqual(json?["speakers_photos"]?.array?.count, try event.speakersPhotos().count)
    XCTAssertEqual(json?["speakers_photos"]?.array?.first?.string, try event.speakersPhotos().first)

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
  
  func fetchPastEvents() throws -> Response {
    let query = "before=\(Date().mysqlString)"
    let request = Request.makeTest(method: .get, query: query)
    let result = try eventContoller.index(request).makeResponse()
    return result
  }
  
  func fetchComingEvents() throws -> Response {
    let query = "after=\(Date().mysqlString)"
    let request = Request.makeTest(method: .get, query: query)
    let result = try eventContoller.index(request).makeResponse()
    return result
  }
  
  func storeEvent() throws -> Identifier? {
    return try EventHelper.storeEvent()
  }
  
  @discardableResult
  func storeComingEvent() throws -> Identifier? {
    return try EventHelper.storeComingEvent()
  }
  
  func storeComingEvents(count: Int) throws {
    for _ in 0..<count {
      try storeComingEvent()
    }
  }
  
  @discardableResult
  func storePastEvent() throws -> Identifier? {
    return try EventHelper.storePastEvent()
  }
  
  func storePastEvents(count: Int) throws {
    for _ in 0..<count {
      try storePastEvent()
    }
  }
  
  func findEvent(by id: Identifier?) throws -> App.Event? {
    return try EventHelper.findEvent(by: id)
  }
}
