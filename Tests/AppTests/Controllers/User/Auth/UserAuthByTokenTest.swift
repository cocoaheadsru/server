import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
class UserAuthByTokenTest: TestCase {

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatGotUnauthorizedWithEmptyAccessToken() throws {
    try! createUser()
    let res = try! drop.clientAuthorizedTestResponse(to: .get, at: "user/1")
    res.assertStatus(is: .unauthorized)
  }

  func testThatGotUnauthorizedWithIncorrectAccessToken() throws {
    let user = try! createUser()

    let token = user.token!
    let bearer = "Bearer " + token

    let clientToken = drop.config["server", "client-token"]?.string ?? ""

    let headers: [HeaderKey: String] = [
      "client-token": clientToken,
      HeaderKey.authorization: bearer,
      HeaderKey.contentType: TestConstants.Header.Value.applicationJson
    ]

    guard let session = try App.Session.find(by: user) else {
      XCTFail("Can't get session for User")
      return
    }
    session.token = try App.Session.generateToken()
    try session.save()

   try! drop.clientAuthorizedTestResponse(
      to: .get,
      at: "user/1",
      headers: headers)
    .assertStatus(is: .unauthorized)
  }

  func testThatGotAccessWithCorrectAccessToken() throws {
    let user = try! createUser()

    let token = user.token!
    let bearer = "Bearer " + token

    let clientToken = drop.config["server", "client-token"]?.string ?? ""

    let headers: [HeaderKey: String] = [
      "client-token": clientToken,
      HeaderKey.authorization: bearer,
      HeaderKey.contentType: TestConstants.Header.Value.applicationJson
    ]

    let res = try! drop.clientAuthorizedTestResponse(
      to: .get,
      at: "user/1",
      headers: headers)

    res.assertStatus(is: .ok)

    guard let returnedJSON = res.json else {
      XCTFail("Can't get JSON for User")
      return
    }

    let json = try! user.makeJSON()
    guard
      let photoURL = json["photo_url"]?.string else {
      XCTFail("Can't get JSON for photo_url")
      return
    }

    var returned =  returnedJSON
    try! returned.set("photo_url", photoURL)
    XCTAssertEqual(returned, try! user.makeJSON())
  }

}

extension UserAuthByTokenTest {
  @discardableResult
  func createUser() throws -> User {
    let user = User()
    try user.save()
    user.createSession()
    return user
  }
}
