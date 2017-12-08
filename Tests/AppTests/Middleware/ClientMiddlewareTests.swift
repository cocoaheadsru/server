import XCTest
import Testing
@testable import Vapor
@testable import App

class ClientMiddlewareTests: TestCase {
  let droplet = try! Droplet.testable()

  let validToken = "test"
  let generatedToken = String.invalidRandomToken

  func testMiddleware_MiddlewarePresentInConfig() {
    let config = droplet.config
    let configMiddlewares = try! config.resolveMiddleware()
    let clientMiddleware = configMiddlewares.filter { $0 is ClientMiddleware }
    XCTAssertTrue(clientMiddleware.count > 0)
  }

  func testConfigInitialization_FailWithoutToken() {
    var config = droplet.config
    config.removeKey("server.client-token")
    XCTAssertThrowsError(try ClientMiddleware(config: config))
  }

  func testConfigInitialization_FailWithEmptyToken() {
    var config = droplet.config
    try! config.set("server.client-token", "")
    XCTAssertThrowsError(try ClientMiddleware(config: config))
  }

  func testConfigInitialization_FailAndThrowsMissingTokenError() {
    var config = droplet.config
    try! config.set("server.client-token", "")
    XCTAssertThrowsError(try ClientMiddleware(config: config)) { error in
      XCTAssertEqual(error as? MiddlewareError, MiddlewareError.missingClientToken)
    }
  }

  func testConfigInitialization_PassWithAnyNonEmptyToken() {
    var config = droplet.config
    try! config.set("server.client-token", generatedToken)
    XCTAssertNoThrow(try ClientMiddleware(config: config))
  }

  func testConfigInitialization_TokenIsAssigned() {
    var config = droplet.config
    try! config.set("server.client-token", generatedToken)
    let middleware = try! ClientMiddleware(config: config)
    XCTAssertEqual(middleware.token, generatedToken)
  }

  func testResponse_PassWithCoincidentToken() {
    let middleware = ClientMiddleware(generatedToken)
    let request = Request(method: .get, uri: "hello", headers: ["client-token": generatedToken])
    let responder = ResponderStub(.notFound)

    let response = try! middleware.respond(to: request, chainingTo: responder)
    XCTAssertEqual(response.status, responder.status)
  }

  func testResponse_FailWithIncoincidentToken() {
    let middleware = ClientMiddleware(generatedToken)
    let request = Request(method: .get, uri: "hello", headers: ["client-token": validToken])
    let responder = ResponderStub()

    let response = try! middleware.respond(to: request, chainingTo: responder)
    XCTAssertEqual(response.status, .unauthorized)
  }
}

// MARK: Manifest

extension ClientMiddlewareTests {
  /// This is a requirement for XCTest on Linux
  /// to function properly.
  /// See ./Tests/LinuxMain.swift for examples
  static let allTests = [
    ("testMiddleware_MiddlewarePresentInConfig",
     testMiddleware_MiddlewarePresentInConfig),
    ("testConfigInitialization_FailWithoutToken",
     testConfigInitialization_FailWithoutToken),
    ("testConfigInitialization_FailWithEmptyToken",
     testConfigInitialization_FailWithEmptyToken),
    ("testConfigInitialization_FailAndThrowsMissingTokenError",
     testConfigInitialization_FailAndThrowsMissingTokenError),
    ("testConfigInitialization_PassWithAnyNonEmptyToken",
     testConfigInitialization_PassWithAnyNonEmptyToken),
    ("testConfigInitialization_TokenIsAssigned",
     testConfigInitialization_TokenIsAssigned),
    ("testResponse_PassWithCoincidentToken",
     testResponse_PassWithCoincidentToken),
    ("testResponse_FailWithIncoincidentToken",
     testResponse_FailWithIncoincidentToken)
  ]
}
