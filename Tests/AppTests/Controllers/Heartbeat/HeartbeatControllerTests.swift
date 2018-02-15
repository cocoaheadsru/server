import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try

class HeartbeatControllerTests: TestCase {
//  let drop = try! Droplet.testable()
  let controller = HeartbeatController()
  let validToken = TestConstants.Middleware.validToken

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatPostSetBeatAnyValue() throws {
    // arrange
    let beat = Int.randomValue
    // act
    guard let res = try! setBeat(to: beat) as? Response else {
      XCTFail("Can't set beat and get current value for beat: \(beat)")
      return
    }
    // assert
    try res.assertJSON("beat", equals: beat)
  }
  
  func testThatRowCountAfterStoreAlwaysBeEqualOne() throws {
    // arrange
    let beat1 = Int.randomValue
    let beat2 = Int.randomValue
    let beat3 = Int.randomValue
    // act
    _ = try! setBeat(to: beat1)
    let count1 = try! Heartbeat.count()
    //assert
    XCTAssert(count1 == 1)
    // act
    _ = try! setBeat(to: beat2)
    let count2 = try! Heartbeat.count()
    // assert
    XCTAssert(count2 == 1)
    // act
    _ = try setBeat(to: beat3)
    let count3 = try! Heartbeat.count()
    // assert
    XCTAssert(count3 == 1)
  }
  
  func testThatShowGet204NoContentForEmptyBeatTable() throws {
    // arange
    try! cleanHeartbeatTable()
    let req = Request.makeTest(method: .get)
    // act
    let res = try! controller.index(req: req).makeResponse()
    // assert
    res.assertStatus(is: .noContent)
  }
  
  func testThatShowGetCurrentValueIfBeatTableIsNotEmpty() throws {
    // arange
    try! cleanHeartbeatTable()
    let beat = Int.randomValue
    _ = try! setBeat(to: beat)
    let req = Request.makeTest(method: .get)
    // act
    let res = try! controller.index(req: req).makeResponse()
    // assert
    try! res.assertJSON("beat", equals: beat)
  }
  
  func testThatRoutePostMethodShouldSetAnyIntValue() throws {
    // arrange
    let beat = Int.randomValue
    let heartbeat = Heartbeat(beat: beat)
    let json = try! heartbeat.makeJSON()
    // act & assert
    print(try! json.serialize(prettyPrint: true).makeString())
    try! drop
      .clientAuthorizedTestResponse(to: .post, at: "heartbeat", body: json)
      .assertStatus(is: .ok)
      .assertJSON("beat", equals: beat)
  }
  
  func testThatRouteGet204NoContentForEmptyBeatTable() throws {
    // arange
    try! cleanHeartbeatTable()
    // act & assert
    try! drop
      .testResponse(to: .get, at: "heartbeat")
      .assertStatus(is: .noContent)
  }
  
  func testThatRouteGetCurrentValueIfBeatTableIsNotEmpty() throws {
    // arange
    try! cleanHeartbeatTable()
    let beat = Int.randomValue
    _ = try! setBeat(to: beat)
    // act & assert
    try! drop
      .testResponse(to: .get, at: "heartbeat")
      .assertStatus(is: .ok)
      .assertJSON("beat", equals: beat)
  }
  
  func testThatRouteHearbeatScenarioIsCorrect() throws {
    
    func makePostRequestForHeartbeat(with beat: Int) throws {
      // arrange
      let heartbeat = Heartbeat(beat: beat)
      let json = try! heartbeat.makeJSON()
      // act & assert
      try! drop
        .clientAuthorizedTestResponse(to: .post, at: "heartbeat", body: json)
        .assertStatus(is: .ok)
        .assertJSON("beat", equals: beat)
      try! drop
        .clientAuthorizedTestResponse(to: .get, at: "heartbeat")
        .assertStatus(is: .ok)
        .assertJSON("beat", equals: beat)
    }
    
    try! makePostRequestForHeartbeat(with: 1)
    try! makePostRequestForHeartbeat(with: 2)
    try! makePostRequestForHeartbeat(with: 1)
    try! makePostRequestForHeartbeat(with: 2)
  }
}

extension HeartbeatControllerTests {
  
  // MARK: - Helper functions & extensions
  func setBeat(to value: Int) throws -> ResponseRepresentable {
    let req = Request.makeTest(method: .post)
    req.json =  try! JSON(node: ["beat": value])
    let res = try! controller.store(req: req).makeResponse()
    return res
  }
  
  fileprivate func cleanHeartbeatTable() throws {
    try Heartbeat.makeQuery().delete()
  }
  
}
