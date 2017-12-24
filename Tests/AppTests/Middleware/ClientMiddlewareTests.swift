import XCTest
import Testing
@testable import Vapor
@testable import App

class ClientMiddlewareTests: TestCase {
  //swiftlint:disable force_try
  let droplet = try! Droplet.testable()
  //swiftlint:enable force_try
  let validToken = TestConstants.Middleware.validToken
  let generatedToken = String.invalidRandomToken

  func testThatMiddlewarePresentInConfig() throws {
    let config = droplet.config
    let configMiddlewares = try config.resolveMiddleware()
    let clientMiddleware = configMiddlewares.filter { $0 is ClientMiddleware }
    XCTAssertTrue(clientMiddleware.count > 0)
  }

  func testThatConfigInitializationFailWithoutToken() {
    var config = droplet.config
    config.removeKey("server.client-token")
    XCTAssertThrowsError(try ClientMiddleware(config: config))
  }

  func testThatConfigInitializationFailWithEmptyToken() throws {
    var config = droplet.config
    try config.set("server.client-token", "")
    XCTAssertThrowsError(try ClientMiddleware(config: config))
  }

  func testThatFailedConfigInitializationThrowsProperError() throws {
    var config = droplet.config
    try config.set("server.client-token", "")
    XCTAssertThrowsError(try ClientMiddleware(config: config)) { error in
      XCTAssertEqual(error as? MiddlewareError, MiddlewareError.missingClientToken)
    }
  }

  func testThatConfigInitializationPassWithAnyNonEmptyToken() throws {
    var config = droplet.config
    try config.set("server.client-token", generatedToken)
    XCTAssertNoThrow(try ClientMiddleware(config: config))
  }

  func testThatTokenIsAssignedFromConfigInitialization() throws {
    var config = droplet.config
    try config.set("server.client-token", generatedToken)
    let middleware = try ClientMiddleware(config: config)
    XCTAssertEqual(middleware.token, generatedToken)
  }

  func testThatResponsePassWithCoincidentToken() throws {
    let middleware = ClientMiddleware(generatedToken)
    let request = Request(method: .get, uri: "hello", headers: ["client-token": generatedToken])
    let responder = ResponderStub(.notFound)

    let response = try middleware.respond(to: request, chainingTo: responder)
    XCTAssertEqual(response.status, responder.status)
  }

  func testThatResponseFailWithIncoincidentToken() throws {
    let middleware = ClientMiddleware(generatedToken)
    let request = Request(method: .get, uri: "hello", headers: ["client-token": validToken])
    let responder = ResponderStub()

    let response = try middleware.respond(to: request, chainingTo: responder)
    XCTAssertEqual(response.status, .unauthorized)
  }
}
