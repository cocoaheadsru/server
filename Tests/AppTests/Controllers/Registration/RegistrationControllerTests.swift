import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

class RegistrationControllerTests: TestCase {
  
  let drop = try! Droplet.testable()
  let controller = RegistrationController()
  let validToken = TestConstants.Middleware.validToken
  
  func testThatRegFromGetNotFoundForWrongId() throws  {
    let wrongId = -1
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongId)/form")
      .assertStatus(is: .notFound)
  }
  
  func tes
  
  
}
