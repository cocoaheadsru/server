import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
class CreatorsControllerTest: TestCase {

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatGetCreatorsReturnsEqualStoredCreatorsCount() throws {

    guard let count = try! generateCreators() else {
      XCTFail("Can't generate creators")
      return
    }

    let response = try! getCreators()
    response.assertStatus(is: .ok)

    guard
      let json = response.json,
      let creators = json.array
      else {
        XCTFail("Can't get creators count from JSON")
        return
    }

    let storedCreatorsCount = creators.count
    XCTAssert(storedCreatorsCount == count, "Expected count \(count), recived count: '\(storedCreatorsCount)'")

  }

}

extension CreatorsControllerTest {

  func getCreators() throws -> Response {
    return try! drop.clientAuthorizedTestResponse(
      to: .get,
      at: "user/creators"
    )
  }

  func generateCreators() throws -> Int? {

    let count = Int.random(min: 3, max: 15)

    for _ in 1...count {
      let user = User()
      try! user.save()
      let creator = Creator(userId: user.id!)
      try! creator.save()
    }

    return count
  }

}
