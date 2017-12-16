import XCTest
import Testing
@testable import Vapor
@testable import App

class EventSpeechControllerTests: TestCase {
  let drop = try! Droplet.testable()
  let eventSpeechContoller = EventSpeechController()
  
  override func setUp() {
    super.setUp()
    try! cleanSpeechTable()
    try! cleanEventTable()
  }
    
  func testThatIndexSpeechesReturnsOkStatus() throws {
    guard let eventId = try storeEvent(), let id = eventId.int else {
      XCTFail()
      return
    }
    
    try storeSpeech(forEventId: eventId)

    let res = try fetchSpeeches(parameterId: id)
    XCTAssertEqual(res.status, .ok)
  }
  
  func testThatIndexSpeechesFailsForEmptyTable() throws {
    let res = try fetchSpeeches(parameterId: Int.randomValue)
    XCTAssertEqual(res.status, .notFound)
  }
  
  func testThatIndexSpeechesReturnsJSONWithAllRequiredFields() throws {
    guard let eventId = try storeEvent(), let id = eventId.int else {
      XCTFail()
      return
    }
    
    try storeSpeech(forEventId: eventId)

    let res = try fetchSpeeches(parameterId: id)
    let json = res.json?.array
    let speechJSON = json?.first
    
    XCTAssertNotNil(json)
    XCTAssertNotNil(speechJSON)
    XCTAssertNotNil(speechJSON?["id"])
    XCTAssertNotNil(speechJSON?["title"])
    XCTAssertNotNil(speechJSON?["description"])
    XCTAssertNotNil(speechJSON?["photo_url"])
    XCTAssertNotNil(speechJSON?["speakers"])
    XCTAssertNotNil(speechJSON?["contents"])
    
    let speakersJSON = speechJSON?["speakers"]?.array
    let speakerJSON = speakersJSON?.first
    XCTAssertNotNil(speakerJSON?["id"])
    XCTAssertNotNil(speakerJSON?["name"])
    XCTAssertNotNil(speakerJSON?["lastname"])
    XCTAssertNotNil(speakerJSON?["photo"])
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
    guard let eventId = try storeEvent(), let id = eventId.int else {
      XCTFail()
      return
    }
    
    try storeSpeech(forEventId: eventId)

    let res = try fetchSpeeches(parameterId: id)
    let json = res.json?.array
    let speechJSON = json?.first
    
    guard let speech = try findEvent(by: eventId)?.speeches().first else {
      XCTFail()
      return
    }
    guard let speaker = try speech.speakers().first else {
      XCTFail()
      return
    }
    guard let user = try speaker.user() else {
      XCTFail()
      return
    }
    guard let content = try speech.contents().first else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(speechJSON?["id"]?.int, speech.id?.int)
    XCTAssertEqual(speechJSON?["title"]?.string, speech.title)
    XCTAssertEqual(speechJSON?["description"]?.string, speech.description)
    XCTAssertEqual(speechJSON?["photo_url"]?.string, speech.photoUrl)
    
    let speakerJSON = speechJSON?["speakers"]?.array?.first
    XCTAssertEqual(speakerJSON?["id"]?.int, speaker.id?.int)
    XCTAssertEqual(speakerJSON?["name"]?.string, user.name)
    XCTAssertEqual(speakerJSON?["lastname"]?.string, user.lastname)
    XCTAssertEqual(speakerJSON?["photo"]?.string, user.photo)
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
    guard let eventId = try storeEvent(), let id = eventId.int else {
      XCTFail()
      return
    }
    
    let expectedSpeechesCount = Int.random(min: 1, max: 6)
    for _ in 0..<expectedSpeechesCount {
      try storeSpeech(forEventId: eventId)
    }
    
    let res = try fetchSpeeches(parameterId: id)
    let arrayJSON = res.json?.array
    
    XCTAssertEqual(arrayJSON?.count, expectedSpeechesCount)
  }
  
  func testThatIndexSpeechesReturnsCorrectSpeakersCount() throws {
    guard let eventId = try storeEvent(), let id = eventId.int else {
      XCTFail()
      return
    }
    
    let expectedSpeakersCount = Int.random(min: 1, max: 6)
    try storeSpeech(forEventId: eventId, speakersCount: expectedSpeakersCount)
    
    let res = try fetchSpeeches(parameterId: id)
    let speechJSON = res.json?.array?.first
    let speakersArrayJSON = speechJSON?["speakers"]?.array
    
    XCTAssertEqual(speakersArrayJSON?.count, expectedSpeakersCount)
  }
  
  func testThatIndexSpeechesReturnsCorrectContentsCount() throws {
    guard let eventId = try storeEvent(), let id = eventId.int else {
      XCTFail()
      return
    }
    
    let expectedContentsCount = Int.random(min: 1, max: 6)
    try storeSpeech(forEventId: eventId, contentCount: expectedContentsCount)
    
    let res = try fetchSpeeches(parameterId: id)
    let speechJSON = res.json?.array?.first
    let contentsArrayJSON = speechJSON?["contents"]?.array
    
    XCTAssertEqual(contentsArrayJSON?.count, expectedContentsCount)
  }
    
  // MARK: Endpoint tests
  
  func testThatGetSpeechesRouteReturnsOkStatus() throws {
    guard let eventId = try storeEvent(), let id = eventId.int else {
      XCTFail()
      return
    }
    
    try storeSpeech(forEventId: eventId)
    
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "/event/\(id)/speech")
      .assertStatus(is: .ok)
  }
}

extension EventSpeechControllerTests {
  
  fileprivate func cleanEventTable() throws {
    try EventHelper.cleanEventTable()
  }
  
  fileprivate func cleanSpeechTable() throws {
    try EventSpeechHelper.cleanSpeechTable()
  }
  
  fileprivate func storeEvent() throws -> Identifier? {
    return try EventHelper.storeEvent()
  }
  
  fileprivate func fetchSpeeches(parameterId: Int) throws -> Response {
    let req = Request.makeTest(method: .get)
    try req.parameters.set("id", parameterId)
    let res = try eventSpeechContoller.index(req: req).makeResponse()
    return res
  }
  
  fileprivate func storeSpeech(
    forEventId eventId: Identifier,
    speakersCount: Int = 2,
    contentCount: Int = 2
  ) throws {
    try EventSpeechHelper.storeSpeech(
      forEventId: eventId,
      speakersCount: speakersCount,
      contentCount: contentCount
    )
  }
  
  fileprivate func findEvent(by id: Identifier?) throws -> App.Event? {
    return try EventHelper.findEvent(by: id)
  }
}
