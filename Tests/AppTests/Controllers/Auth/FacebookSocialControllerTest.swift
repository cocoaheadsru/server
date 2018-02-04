import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
class FacebookSocialControllerTest: TestCase {

  var drop: Droplet!

  override func setUp() {
    super.setUp()
    do {
      drop = try Droplet.testable()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatUserCreatedAndStoredFromFacebookAccount() throws {

    guard let body = try! FacebookAuthControllerTestHelper.getTestRequest(config: drop.config) else {
      XCTFail("Can't get test request")
      return
    }

    let clientHeaders: [HeaderKey: String] = [
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]

    let user = try! drop
      .clientAuthorizedTestResponse(
        to: .post,
        at: "user/auth",
        headers: clientHeaders,
        body: body)
      .assertStatus(is: .ok)

    guard
      let returned = user.json,
      let id = returned["id"]?.int
    else {
      XCTFail("Can't get user id from response")
      return
    }

    guard let userInfoFromSocial = try! FacebookAuthControllerTestHelper.getUserInfoFromSocial(drop: drop) else {
      XCTFail("Can't get test user info from social")
      return
    }

    guard let storedUser = try User.find(id) else {
      XCTFail("Can't get test user info from Database")
      return
    }

    let stored = try storedUser.makeJSON()
    var expected = userInfoFromSocial
    try expected.set("id", id)

    print("\n\n*** EXPECTED JSON ***\n\n")
    print(try expected.serialize(prettyPrint: true).makeString())
    print("\n\n*** RETURNED JSON ***\n\n")
    print(try returned.serialize(prettyPrint: true).makeString())
    print("\n\n*** STORED JSON ***\n\n")
    print(try returned.serialize(prettyPrint: true).makeString())

    XCTAssertEqual(expected, stored)

  }

  func testThatSessionTokenCreatedAndStoredFromFacebookAccount() throws {

    guard let body = try! FacebookAuthControllerTestHelper.getTestRequest(config: drop.config) else {
      XCTFail("Can't get test request")
      return
    }

    let clientHeaders: [HeaderKey: String] = [
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]

    let user = try! drop
      .clientAuthorizedTestResponse(
        to: .post,
        at: "user/auth",
        headers: clientHeaders,
        body: body)
      .assertStatus(is: .ok)

    guard
      let returned = user.json,
      let token = returned["token"]?.string
    else {
      XCTFail("Can't get user token from response")
      return
    }

    let userSession = try! FacebookAuthControllerTestHelper.getUserSessionToken(by: returned)
    print("\nUser session token:\(userSession!)\n")
    XCTAssertNotNil(userSession)
    XCTAssertEqual(userSession, token)

  }
}
