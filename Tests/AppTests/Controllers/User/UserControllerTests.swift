import XCTest
import Testing
import HTTP
import Sockets
@testable import Vapor
@testable import App

class UserControllerTests: TestCase {
  let drop = try! Droplet.testable()
  
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
    try! cleanUserTable()
  }

  func testThatUserCreatesFromRequest() throws {
    let userJSON = try generatedUserJSON()
    
    try sendPostRequest(with: userJSON)
    XCTAssertEqual(try User.all().count, 1)
  }
  
  func testThatUserDoesNotCreateFromIncompleteRequest() throws {
    var json = JSON()
    try json.set("name", firstName)
    
    try drop.clientAuthorizedTestResponse(to: .post, at: "user", body: json).assertStatus(is: .internalServerError)
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
    let user = try storeUser()
    let token = try user.session()?.token
    
    try sendGetRequest(for: user.id!)
    
    XCTAssertEqual(token, try user.session()?.token)
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
  
  func testThatUpdateMethodUpdatesUserCredentials() throws {
    let user = try storeUser()
    var updatedUserJSON = try generatedUserJSON()
    try updatedUserJSON.set("lastname", updatedLastName)

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
    let newPhoto = String.randomURL
    
    var json = JSON()
    try json.set("name", newName)
    try json.set("lastname", newLastName)
    try json.set("company", newCompany)
    try json.set("position", newPosition)
    try json.set("email", newEmail)
    try json.set("photo", newPhoto)
    
    let response = try drop.clientAuthorizedTestResponse(to: .patch, at: "/user/\((user.id?.int)!)", body: json)
    
    try response.assertJSON("name", equals: newName)
    try response.assertJSON("lastname", equals: newLastName)
    try response.assertJSON("company", equals: newCompany)
    try response.assertJSON("position", equals: newPosition)
    try response.assertJSON("email", equals: newEmail)
    try response.assertJSON("photo", equals: newPhoto)
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
      try json.set("photo", photo)
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
  
  @discardableResult
  func sendPatchRequest(for id: Identifier, with json: JSON) throws -> Response {
    return try drop.clientAuthorizedTestResponse(to: .patch, at: "/user/\(id.int!)", body: json)
  }
}
