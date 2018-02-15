import XCTest
import Testing
import HTTP
import Sockets
@testable import Vapor
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
class UserControllerTests: TestCase {
  
  let firstName = "Cocoa"
  let lastName = "Heads"
  let company = "CocoaHeads"
  let position = "Tester"
  let email = "tester@cocoaheads.ru"
  let phone = "1234567890"
  let photo = "http://cocoaheads.ru/photo.jpg"
  let updatedLastName = "Feet"

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatSessionTokenDoesNotUpdateOnEveryShowRequest() throws {
    let user = try! storeUser()
    let token = try! user.session()?.token
    
    try sendGetRequest(for: user)
    
    XCTAssertEqual(token, try! user.session()?.token)
  }

  func testThatShowMethodUpdatesSessionTokenAfterOneMonth() throws {
    let user = try! storeUser()
    let session = try! user.session()
    let formatter = isoFormatter()
    
    let newUpdatedAt = Calendar.current.date(byAdding: .month, value: -2, to: Date())

    try Session.database?.raw(
      """
        UPDATE session
        SET updated_at = '\(formatter.string(from: newUpdatedAt!))'
        WHERE session.id = \((session?.id?.int)!)
      """
    )
    
    try sendGetRequest(for: user)
    
    let updatedAt = try! user.session()?.updatedAt
    let updatedAtMonth = Calendar.current.component(.month, from: updatedAt!)
    let currentMonth = Calendar.current.component(.month, from: Date())
    
    XCTAssertEqual(updatedAtMonth, currentMonth)
  }
  
  func testThatUpdateMethodUpdatesUserCredentials() throws {
    let user = try! storeUser()
    var updatedUserJSON = try! generatedUserJSON()
    try! updatedUserJSON.set("lastname", updatedLastName)
    try! updatedUserJSON.set("token", try! user.token())

    try sendPatchRequest(for: user.id!, with: updatedUserJSON)
    
    let updatedUser = try User.find(user.id!)
    
    XCTAssertEqual(updatedUser!.lastname, updatedLastName)
  }
  
  func testThatUpdateMethodReturnsUpdatedUser() throws {
    let user = try storeUser()
    let newName = String.randomValue
    let newLastName = String.randomValue
    let newCompany = String.randomValue
    let newPosition = String.randomValue
    let newEmail = String.randomEmail

    var json = JSON()
    try! json.set("name", newName)
    try! json.set("lastname", newLastName)
    try! json.set("company", newCompany)
    try! json.set("position", newPosition)
    try! json.set("email", newEmail)
    try! json.set("token", try! user.token())

    let response = try! drop
      .userAuthorizedTestResponse(
        to: .patch,
        at: "/user/\((user.id?.int)!)",
        body: json)

    try! response.assertJSON("name", equals: newName)
    try! response.assertJSON("lastname", equals: newLastName)
    try! response.assertJSON("company", equals: newCompany)
    try! response.assertJSON("position", equals: newPosition)
    try! response.assertJSON("email", equals: newEmail)
  }

}

extension UserControllerTests {

  func cleanUserTable() throws {
    try! Session.makeQuery().delete()
    try! User.makeQuery().delete()
  }

  func generatedUserJSON(full: Bool = false) throws -> JSON {
    var json = JSON()
    try! json.set("name", firstName)
    try! json.set("lastname", lastName)
    if full {
      try! json.set("company", company)
      try! json.set("position", position)
      try! json.set("email", email)
      try! json.set("phone", phone)
      try! json.set("photo", photo)
    }
    return json
  }
  
  func isoFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return formatter
  }

  func storeUser() throws -> User {
    let user = User()
    try! user.save()
    return user
  }

  @discardableResult
  func sendGetRequest(for user: User) throws -> Response {
    return try! drop.userAuthorizedTestResponse(
      to: .get,
      at: "/user/\(user.id!.int!)",
      bearer: try! user.token()
    )
  }
  
  @discardableResult
  func sendPatchRequest(for id: Identifier, with json: JSON) throws -> Response {
    return try! drop.userAuthorizedTestResponse(
      to: .patch,
      at: "/user/\(id.int!)",
      body: json)
  }
}
