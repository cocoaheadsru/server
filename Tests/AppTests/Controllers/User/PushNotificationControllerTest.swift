import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
class PushNotificationControllerTest: TestCase {

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatPushTokenIsRegistered() throws {

    let user = User()
    try! user.save()

    let pushToken = String.randomValue

    let body = try! JSON(node: ["push_token": pushToken])

    try! subscribeNotification(for: user, with: body).assertStatus(is: .ok)

     let count = try! App.Client.makeQuery()
      .filter(App.Client.Keys.pushToken, pushToken)
      .filter(App.Client.Keys.userId, 1).count()

    XCTAssert(count == 1, "Expected count 1, recived count: '\(count)'")
  }

  func testThatPushTokenIsRegisteredOnlyOnceForCertainUser() throws {

    let user = User()
    try! user.save()

    // create
    let pushToken = String.randomValue
    let body = try! JSON(node: ["push_token": pushToken])

    try! subscribeNotification(for: user, with: body).assertStatus(is: .ok)

    let count = try! App.Client.makeQuery()
      .filter(App.Client.Keys.pushToken, pushToken)
      .filter(App.Client.Keys.userId, 1).count()

    XCTAssert(count == 1, "Expected count 1, recived count: '\(count)'")

    // update
    let pushTokenUpdated = String.randomValue
    let bodyUpdated = try! JSON(node: ["push_token": pushTokenUpdated])

    try! subscribeNotification(for: user, with: bodyUpdated).assertStatus(is: .ok)

    let countUpdated = try! App.Client.makeQuery()
      .filter(App.Client.Keys.pushToken, pushTokenUpdated)
      .filter(App.Client.Keys.userId, 1).count()

    XCTAssert(countUpdated == 1, "Expected count 1, recived count: '\(countUpdated)'")

  }

  func testThatPushNotificationIsCanceled() throws {

    let user = User()
    try! user.save()

    let pushToken = String.randomValue

    let body = try! JSON(node: ["push_token": pushToken])

    try! subscribeNotification(for: user, with: body).assertStatus(is: .ok)

    let count = try! App.Client.makeQuery()
      .filter(App.Client.Keys.pushToken, pushToken)
      .filter(App.Client.Keys.userId, 1).count()

    XCTAssert(count == 1, "Expected count 1, recived count: '\(count)'")

    try! cancelNotification(for: user).assertStatus(is: .ok)

    let countAfterCancelNotification = try! App.Client.makeQuery()
      .filter(App.Client.Keys.pushToken, pushToken)
      .filter(App.Client.Keys.userId, 1).count()

    XCTAssert(countAfterCancelNotification == 0, "Expected count 0, recived count: '\(countAfterCancelNotification)'")
  }

}

extension PushNotificationControllerTest {

  func subscribeNotification(for user: User, with body: JSON) throws -> Response {
    return try! drop.userAuthorizedTestResponse(
      to: .post,
      at: "user/notification",
      body: body,
      bearer: try! user.token())
  }

  func cancelNotification(for user: User) throws -> Response {

    guard let userId: Int = user.id?.int else {
      XCTFail("Can't got userId")
      return Response(status: .internalServerError)
    }

    return try! drop.userAuthorizedTestResponse(
      to: .delete,
      at: "user/notification/\(userId)",
      bearer: try! user.token())
  }
  
}
