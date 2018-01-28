import XCTest
import Testing
import HTTP
import Sockets
@testable import Vapor
@testable import App

class UserControllerTests: TestCase {
  let drop = try! Droplet.testable()
  let userContoller = UserController()
  
  let firstName = "Cocoa"
  let lastName = "Heads"
  let company = "CocoaHeads"
  let position = "Tester"
  let email = "tester@cocoaheads.ru"
  let phone = "1234567890"
  let updatedLastName = "Feet"
  
  override func setUp() {
    super.setUp()
    try! cleanUserTable()
  }

  func testThatUserCreatesFromRequest() throws {
    let userJSON = try generatedUserJSON()
    
    try sendPostRequest(with: userJSON)
    XCTAssertEqual(try User.all().count, 1)
  }
  
  func testThatUserDoesNotCreateFromIncompleteRequest() throws {
    var json = JSON()
    try! json.set("name", firstName)
    
    try! drop.clientAuthorizedTestResponse(to: .post, at: "user", body: json).assertStatus(is: .internalServerError)
  }

  func testThatStoreMethodReturnsUser() throws {
    let userJSON = try generatedUserJSON(full: true)
    let response = try drop.clientAuthorizedTestResponse(to: .post, at: "/user", body: userJSON)
    
    XCTAssertEqual(response.json?["name"]?.string, firstName)
    XCTAssertEqual(response.json?["lastname"]?.string, lastName)
    XCTAssertEqual(response.json?["company"]?.string, company)
    XCTAssertEqual(response.json?["position"]?.string, position)
    XCTAssertEqual(response.json?["email"]?.string, email)
    XCTAssertEqual(response.json?["phone"]?.string, phone)
  }

  func testThatStoreMethodCreatesUserSession() throws {
    let userJSON = try generatedUserJSON()
    
    try sendPostRequest(with: userJSON)
    XCTAssertEqual(try Session.all().count, 1)
  }

  func testThatSessionTokenDoesNotUpdateOnEveryShowRequest() throws {
    let user = try! storeUser()
    let token = try! user.session()?.token
    
    try! sendGetRequest(for: user.id!)
    
    XCTAssertEqual(token, try! user.session()?.token)
  }

  func testThatShowMethodUpdatesSessionTokenAfterOneMonth() throws {
    let user = try storeUser()
    let session = try user.session()
    let formatter = isoFormatter()
    
    let newUpdatedAt = Calendar.current.date(byAdding: .month, value: -2, to: Date())

    try Session.database?.raw(
      """
        UPDATE session
        SET updated_at = '\(formatter.string(from: newUpdatedAt!))'
        WHERE session.id = \((session?.id?.int)!)
      """
    )
    
    try sendGetRequest(for: user.id!)
    
    let updatedAt = try user.session()?.updatedAt
    let updatedAtMonth = Calendar.current.component(.month, from: updatedAt!)
    let currentMonth = Calendar.current.component(.month, from: Date())
    
    XCTAssertEqual(updatedAtMonth, currentMonth)
  }
}

extension UserControllerTests {

  func cleanUserTable() throws {
    try Session.makeQuery().delete()
    try User.makeQuery().delete()
  }

  func generatedUserJSON(full: Bool = false) throws -> JSON {
    var json = JSON()
    try json.set("name", firstName)
    try json.set("lastname", lastName)
    if full {
      try json.set("company", company)
      try json.set("position", position)
      try json.set("email", email)
      try json.set("phone", phone)
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
    try user.save()
    return user
  }
  
  @discardableResult
  func sendPostRequest(with json: JSON) throws -> Response {
    return try drop.clientAuthorizedTestResponse(to: .post, at: "/user", body: json)
  }
  
  @discardableResult
  func sendGetRequest(for id: Identifier) throws -> Response {
    return try drop.clientAuthorizedTestResponse(to: .get, at: "/user/\(id.int!)")
  }
}
