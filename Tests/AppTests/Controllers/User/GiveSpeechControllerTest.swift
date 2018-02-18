import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
class GiveSeechControllerTest: TestCase {

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatGiveSpeechIsPosted() throws {

    let user = User()
    try! user.save()

    let title = String.randomValue
    let description = String.randomValue + "\n" + String.randomValue + "\n" + String.randomValue

    let body = try! JSON( node:[
      "title": title,
      "description": description
    ])

    try! postSpeech(for: user, with: body).assertStatus(is: .ok)

    let speeches = try! GiveSpeech.makeQuery()
      .filter(GiveSpeech.Keys.title, title)
      .filter(GiveSpeech.Keys.description, description)
      .all()

     XCTAssert(speeches.count == 1, "Expected count 1, recived count: '\(speeches.count)'")

    let speakerJSON = try! speeches.first?.user()?.makeJSON()

    XCTAssertEqual(speakerJSON!, try! user.makeJSON())

  }

}

extension GiveSeechControllerTest {

  func postSpeech(for user: User, with body: JSON) throws -> Response {
    return try! drop.userAuthorizedTestResponse(
      to: .post,
      at: "user/give-speech",
      body: body,
      bearer: try! user.token())
  }

}
