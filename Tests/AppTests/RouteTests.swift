import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import App

class RouteTests: TestCase {
  let drop = try! Droplet.testable()

  func testUnathorizedRequest() throws {
    try drop
      .unauthorizedTestResponse(to: .get, at: "hello")
      .assertStatus(is: .unauthorized)
  }

  func testAppAuthorizedRequest() throws {
    try drop
      .appAuthorizedTestResponse(to: .get, at: "hello")
      .assertStatus(is: .ok)
  }

  func testFailedAppAuthorizedRequest() throws {
    let randomToken = String.invalidRandomToken
    try drop
      .unauthorizedTestResponse(to: .get, at: "hello", headers: ["client-token": randomToken])
      .assertStatus(is: .unauthorized)
  }

  func testHello() throws {
    try drop
      .appAuthorizedTestResponse(to: .get, at: "hello")
      .assertStatus(is: .ok)
      .assertJSON("hello", equals: "world")
  }

  func testPlainText() throws {
    try drop
      .appAuthorizedTestResponse(to: .get, at: "plaintext")
      .assertStatus(is: .ok)
      .assertBody(contains: "Hello, world!")
  }
}

// MARK: Manifest

extension RouteTests {
  /// This is a requirement for XCTest on Linux
  /// to function properly.
  /// See ./Tests/LinuxMain.swift for examples
  static let allTests = [
    ("testHello", testHello),
    ("testPlainText", testPlainText),
    ("testUnathorizedRequest", testUnathorizedRequest),
    ("testAppAuthorizedRequest", testAppAuthorizedRequest),
    ("testFailedAppAuthorizedRequest", testFailedAppAuthorizedRequest)
  ]
}
