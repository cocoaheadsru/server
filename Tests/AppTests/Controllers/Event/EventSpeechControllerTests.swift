import XCTest
import Testing
@testable import Vapor
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
class EventSpeechControllerTests: TestCase {

  let eventSpeechContoller = EventSpeechController()
  
  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }
    
  func testThatIndexSpeechesReturnsOkStatus() throws {
    guard let eventId = try! storeEvent(), let id = eventId.int else {
      XCTFail("Can't get eventId")
      return
    }
    
    try! storeSpeech(for: eventId)

    let res = try! fetchSpeeches(by: id)
    XCTAssertEqual(res.status, .ok)
  }
  
  func testThatIndexSpeechesFailsWithIncorrectParameter() throws {
    let request = Request.makeTest(method: .get)
    try request.parameters.set(EventSpeechHelper.invalidParameterKey, Int.randomValue)
    XCTAssertThrowsError(try eventSpeechContoller.index(request: request).makeResponse())
  }
  
  func testThatIndexSpeechesReturnsJSONWithAllRequiredFields() throws {
    guard let eventId = try! storeEvent(), let id = eventId.int else {
      XCTFail("Can't get eventId")
      return
    }
    
    try storeSpeech(for: eventId)

    let response = try! fetchSpeeches(by: id)
    let speechJSON = response.json?.array?.first
    
    XCTAssertNotNil(speechJSON)
    XCTAssertNotNil(speechJSON?["id"])
    XCTAssertNotNil(speechJSON?["title"])
    XCTAssertNotNil(speechJSON?["description"])
    XCTAssertNotNil(speechJSON?["speakers"])
    XCTAssertNotNil(speechJSON?["contents"])
    
    let speakersJSON = speechJSON?["speakers"]?.array
    let speakerJSON = speakersJSON?.first
    XCTAssertNotNil(speakerJSON?["id"])
    XCTAssertNotNil(speakerJSON?["name"])
    XCTAssertNotNil(speakerJSON?["lastname"])
    XCTAssertNotNil(speakerJSON?["photo_url"])
    XCTAssertNotNil(speakerJSON?["phone"])
    XCTAssertNotNil(speakerJSON?["company"])
    XCTAssertNotNil(speakerJSON?["email"])
    XCTAssertNotNil(speakerJSON?["position"])
    
    let contentsJSON = speechJSON?["contents"]?.array
    let contentJSON = contentsJSON?.first
    XCTAssertNotNil(contentJSON?["id"])
    XCTAssertNotNil(contentJSON?["title"])
    XCTAssertNotNil(contentJSON?["description"])
    XCTAssertNotNil(contentJSON?["link"])
    XCTAssertNotNil(contentJSON?["type"])
  }
  
  func testThatIndexSpeechesReturnsJSONWithExpectedFields() throws {
    guard let eventId = try! storeEvent(), let id = eventId.int else {
      XCTFail("Can't get eventId")
      return
    }
    
    try storeSpeech(for: eventId)
    
    let response = try fetchSpeeches(by: id)
    let speechJSON = response.json?.array?.first
    
    guard
      let speech = try! findEvent(by: eventId)?.speeches().first,
      let speaker = try! speech.speakers().first,
      let user = try! speaker.user(),
      let content = try! speech.contents().first
    else {
      XCTFail("Can't prepare stage")
      return
    }
    
    let photoPath = "\(TestConstants.Path.userPhotosPath + (user.id?.string)!)/\(user.photo!)"
    
    XCTAssertEqual(speechJSON?["id"]?.int, speech.id?.int)
    XCTAssertEqual(speechJSON?["title"]?.string, speech.title)
    XCTAssertEqual(speechJSON?["description"]?.string, speech.description)
    
    let speakerJSON = speechJSON?["speakers"]?.array?.first
    XCTAssertEqual(speakerJSON?["id"]?.int, speaker.id?.int)
    XCTAssertEqual(speakerJSON?["name"]?.string, user.name)
    XCTAssertEqual(speakerJSON?["lastname"]?.string, user.lastname)
    XCTAssertEqual(speakerJSON?["photo_url"]?.string, photoPath)
    XCTAssertEqual(speakerJSON?["phone"]?.string, user.phone)
    XCTAssertEqual(speakerJSON?["company"]?.string, user.company)
    XCTAssertEqual(speakerJSON?["email"]?.string, user.email)
    XCTAssertEqual(speakerJSON?["position"]?.string, user.position)

    let contentJSON = speechJSON?["contents"]?.array?.first
    XCTAssertEqual(contentJSON?["id"]?.int, content.id?.int)
    XCTAssertEqual(contentJSON?["title"]?.string, content.title)
    XCTAssertEqual(contentJSON?["description"]?.string, content.description)
    XCTAssertEqual(contentJSON?["link"]?.string, content.link)
    XCTAssertEqual(contentJSON?["type"]?.string, content.type.string)
  }
  
  func testThatIndexSpeechesReturnsCorrectSpeechesCount() throws {
    guard let eventId = try! storeEvent(), let id = eventId.int else {
      XCTFail("Can't get eventId")
      return
    }
    
    let expectedSpeechesCount = Int.random(min: 1, max: 6)
    try! storeSpeeches(count: expectedSpeechesCount, for: eventId)
    
    let response = try! fetchSpeeches(by: id)
    let arrayJSON = response.json?.array
    
    XCTAssertEqual(arrayJSON?.count, expectedSpeechesCount)
  }
  
  func testThatIndexSpeechesReturnsCorrectSpeakersCount() throws {
    guard let eventId = try storeEvent(), let id = eventId.int else {
      XCTFail("Can't get eventId")
      return
    }
    
    let expectedSpeakersCount = Int.random(min: 1, max: 6)
    try storeSpeech(for: eventId, speakersCount: expectedSpeakersCount)
    
    let response = try! fetchSpeeches(by: id)
    let speechJSON = response.json?.array?.first
    let speakersArrayJSON = speechJSON?["speakers"]?.array
    
    XCTAssertEqual(speakersArrayJSON?.count, expectedSpeakersCount)
  }
  
  func testThatIndexSpeechesReturnsCorrectContentsCount() throws {
    guard let eventId = try! storeEvent(), let id = eventId.int else {
      XCTFail("Can't get eventId")
      return
    }
    
    let expectedContentsCount = Int.random(min: 1, max: 6)
    try storeSpeech(for: eventId, contentCount: expectedContentsCount)
    
    let response = try! fetchSpeeches(by: id)
    let speechJSON = response.json?.array?.first
    let contentsArrayJSON = speechJSON?["contents"]?.array
    
    XCTAssertEqual(contentsArrayJSON?.count, expectedContentsCount)
  }
    
  // MARK: Endpoint tests
  
  func testThatGetSpeechesRouteReturnsOkStatus() throws {
    guard let eventId = try! storeEvent(), let id = eventId.int else {
      XCTFail("Can't get eventId")
      return
    }
    
    try! storeSpeech(for: eventId)
    
    try! drop
      .clientAuthorizedTestResponse(to: .get, at: "/event/\(id)/speech")
      .assertStatus(is: .ok)
  }
  
  func testThatGetSpeechesRouteFailsForEmptyTable() throws {
    try! drop
      .clientAuthorizedTestResponse(to: .get, at: "/event/\(Int.randomValue)/speech")
      .assertStatus(is: .notFound)
  }
  
  func testThatGetSpeechesRouteFailsWithNonIntParameterValue() throws {
    try! drop
      .clientAuthorizedTestResponse(to: .get, at: "/event/\(EventSpeechHelper.invalidParameterValue)/speech")
      .assertStatus(is: .badRequest)
  }
}

fileprivate extension EventSpeechControllerTests {

  func storeEvent() throws -> Identifier? {
    return try EventHelper.storeEvent()
  }
  
  func fetchSpeeches(by id: Int) throws -> Response {
    let request = Request.makeTest(method: .get)
    try request.parameters.set("id", id)
    let response = try eventSpeechContoller.index(request: request).makeResponse()
    return response
  }
  
  func storeSpeech(
    for eventId: Identifier,
    speakersCount: Int = 2,
    contentCount: Int = 2
  ) throws {
    try EventSpeechHelper.storeSpeech(
      for: eventId,
      speakersCount: speakersCount,
      contentCount: contentCount
    )
  }
  
  func storeSpeeches(count: Int, for eventId: Identifier) throws {
    for _ in 0..<count {
      try storeSpeech(for: eventId)
    }
  }
  
  func findEvent(by id: Identifier?) throws -> App.Event? {
    return try EventHelper.findEvent(by: id)
  }
}
