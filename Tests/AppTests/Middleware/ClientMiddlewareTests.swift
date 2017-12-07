import XCTest
import Testing
@testable import Vapor
@testable import App

class ClientMiddlewareTests: TestCase {
  let droplet = try! Droplet.testable()

  let validClientToken = "test"
  let invalidClientToken = String.invalidRandomToken

  func testMiddleware_MiddlewarePresentInConfig() {
    let config = droplet.config
    let configMiddlewares = try! config.resolveMiddleware()
    XCTAssertTrue(configMiddlewares.contains { middleware in
      if let _ = middleware as? ClientMiddleware {
        return true
      }
      return false
    })
  }

  func testMiddleware_ClientTokenIsTakenFromConfig() {
    let config = droplet.config
    XCTAssertEqual(config["server", "client-token"]?.string, validClientToken)
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
    try! config.set("server.client-token", invalidClientToken)
    XCTAssertNoThrow(try ClientMiddleware(config: config))
  }

  func testConfigInitialization_TokenIsAssigned() {
    var config = droplet.config
    try! config.set("server.client-token", invalidClientToken)
    let middleware = try! ClientMiddleware(config: config)
    XCTAssertEqual(middleware.token, invalidClientToken)
  }

  func testResponse_PassWithCoincidentToken() {
    let middleware = ClientMiddleware(invalidClientToken)
    let request = Request(method: .get, uri: "hello", headers: ["client-token": invalidClientToken])
    let responder = ResponderStub(.notFound)

    let response = try! middleware.respond(to: request, chainingTo: responder)
    XCTAssertEqual(response.status, responder.status)
  }

  func testResponse_FailWithIncoincidentToken() {
    let middleware = ClientMiddleware(invalidClientToken)
    let request = Request(method: .get, uri: "hello", headers: ["client-token": validClientToken])
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
    ("testMiddleware_ClientTokenIsTakenFromConfig",
     testMiddleware_ClientTokenIsTakenFromConfig),
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
