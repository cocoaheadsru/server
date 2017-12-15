import XCTest
import Testing
@testable import Vapor
@testable import App

class EventSpeechControllerTests: TestCase {
  let drop = try! Droplet.testable()
  let eventSpeechContoller = EventSpeechController()
    
  func testThatIndexEventReturnsOkStatus() throws {
    try cleanSpeechTable()
    try cleanEventTable()
    guard let eventId = try storeEvent(), let id = eventId.int else {
      XCTFail()
      return
    }
    
    try storeSpeech(forEventId: eventId)
    
    let req = Request.makeTest(method: .get)
    try req.parameters.set("id", id)
    
    let res = try eventSpeechContoller.index(req: req).makeResponse()
    
    XCTAssertEqual(res.status, .ok)
  }
  
  func testThatIndexEventFailsForEmptyTable() throws {
    try cleanSpeechTable()
    try cleanEventTable()
    
    let req = Request.makeTest(method: .get)
    try req.parameters.set("id", Int.randomValue)
    
    let res = try eventSpeechContoller.index(req: req).makeResponse()
    
    XCTAssertEqual(res.status, .notFound)
  }
    
  // MARK: Endpoint tests
  
  func testThatGetSpeechesForEventRouteReturnsOkStatus() throws {
    try cleanSpeechTable()
    try cleanEventTable()
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
  
  fileprivate func storeSpeech(forEventId eventId: Identifier) throws {
    try EventSpeechHelper.storeSpeech(forEventId: eventId)
  }
}
