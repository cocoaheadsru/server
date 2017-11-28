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
    let randomToken = String.randomToken
    try drop
      .unauthorizedTestResponse(to: .get, at: "hello", headers: ["app-token": randomToken])
      .assertStatus(is: .unauthorized)
  }
  
  func testHello() throws {
    try drop
      .appAuthorizedTestResponse(to: .get, at: "hello")
      .assertStatus(is: .ok)
      .assertJSON("hello", equals: "world")
  }
  
  func testInfo() throws {
    try drop
      .appAuthorizedTestResponse(to: .get, at: "info")
      .assertStatus(is: .ok)
      .assertBody(contains: "0.0.0.0")
  }
}

// MARK: Manifest

extension RouteTests {
  /// This is a requirement for XCTest on Linux
  /// to function properly.
  /// See ./Tests/LinuxMain.swift for examples
  static let allTests = [
    ("testHello", testHello),
    ("testInfo", testInfo),
    ("testUnathorizedRequest", testUnathorizedRequest),
    ("testAppAuthorizedRequest", testAppAuthorizedRequest),
    ("testFailedAppAuthorizedRequest", testFailedAppAuthorizedRequest)
  ]
}
