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

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatUserIsCreatedAndStoredFromFacebookAccount() throws {

    guard let body = try! FacebookAuthControllerTestHelper.getTestRequest(config: drop.config) else {
      XCTFail("Can't get test request")
      return
    }

    let user = try! postUserAuth(body: body).assertStatus(is: .ok)

    guard
      let returnedJSON = user.json,
      let id = returnedJSON["id"]?.int
    else {
      XCTFail("Can't get user id from response")
      return
    }

    var returned = returnedJSON
    returned.removeKey("id")
    returned.removeKey("token")

    guard let expected = try! FacebookAuthControllerTestHelper.getUserInfoFromSocial(drop: drop) else {
      XCTFail("Can't get test user info from social")
      return
    }

    guard let storedUser = try User.find(id) else {
      XCTFail("Can't get test user info from Database")
      return
    }

    let stored = try storedUser.makeJSON()

    print("\n\n*** EXPECTED JSON ***\n\n")
    print(try expected.serialize(prettyPrint: true).makeString())
    print("\n\n*** RETURNED JSON ***\n\n")
    print(try returned.serialize(prettyPrint: true).makeString())
    print("\n\n*** STORED JSON ***\n\n")
    print(try stored.serialize(prettyPrint: true).makeString())

    XCTAssertEqual(expected, returned)

  }

  func testThatSessionTokenIsCreatedAndStoredFromFacebookAccount() throws {

    guard let body = try! FacebookAuthControllerTestHelper.getTestRequest(config: drop.config) else {
      XCTFail("Can't get test request")
      return
    }

    let user = try! postUserAuth(body: body).assertStatus(is: .ok)

    guard
      let returned = user.json,
      let token = returned["token"]?.string
    else {
      XCTFail("Can't get user token from response")
      return
    }

    let userSession = try! SocialAuthControllerTestHelper.getUserSessionToken(by: returned)
    print("\nUser session token:\(userSession!)\n")
    XCTAssertNotNil(userSession)
    XCTAssertEqual(userSession, token)

  }

  func testThatIfUserExistThenUserProfileUpdatedFromFacebook() throws {

    guard let body = try! FacebookAuthControllerTestHelper.getTestRequest(config: drop.config) else {
      XCTFail("Can't get test request")
      return
    }

    let user = try! postUserAuth(body: body).assertStatus(is: .ok)

    guard
      let returned = user.json,
      let token = returned["token"]?.string
      else {
        XCTFail("Can't get user token from response")
        return
    }

    print("\n Token for new user: '\(token)'")

    _ = try! postUserAuth(body: body).assertStatus(is: .ok)

    let userCount = try User.count()
    XCTAssertTrue(userCount == 1, "We must update user,  don't create once more.. User count is: \(userCount)")

  }

  func testThatUserPhotoFromFacebookIsSaved() throws {
    guard let body = try! FacebookAuthControllerTestHelper.getTestRequest(config: drop.config) else {
      XCTFail("Can't get test request")
      return
    }

    let fileName = "1716396_original2.jpg"
    let photoPath = "user_photos/1/"
    let filePath = drop.config.workDir + "Tests/Resources/" + fileName
    let fileManager = Foundation.FileManager()
    let storedDir = drop.config.publicDir + photoPath

    try! fileManager.removeAllFiles(atPath: storedDir)

    let response = try! postUserAuth(body: body).assertStatus(is: .ok)

    guard
      let updatedUser = response.json,
      let newPhotoURL = updatedUser["photo_url"]?.string,
      let photoFileName = URL(string: newPhotoURL)?.lastPathComponent
      else {
        XCTFail("Can't get photo path")
        return
    }

    let storedFilePath = storedDir + photoFileName
    XCTAssertTrue( try! CryptoHasher.compareFiles(filePath1: filePath, filePath2: storedFilePath))

  }

}

extension  FacebookSocialControllerTest {

  func postUserAuth(body: JSON) throws -> Response {
    return try! drop
      .clientAuthorizedTestResponse(
        to: .post,
        at: "user/auth",
        body: body)
  }

}
