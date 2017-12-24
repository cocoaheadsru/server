import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import App

class RouteTests: TestCase {
  //swiftlint:disable force_try
  let drop = try! Droplet.testable()
  //swiftlint:eanble force_try
  func testThatRequestWithNoClientTokenFails() throws {
    try drop
      .unauthorizedTestResponse(to: .get, at: "hello")
      .assertStatus(is: .unauthorized)
  }

  func testThatAuthorizedRequestPasses() throws {
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "hello")
      .assertStatus(is: .ok)
  }

  func testThatRequestWithInvalidClientTokenFails() throws {
    let randomToken = String.invalidRandomToken
    try drop
      .unauthorizedTestResponse(to: .get, at: "hello", headers: ["client-token": randomToken])
      .assertStatus(is: .unauthorized)
  }

  func testThatRequestToHelloReturnsProperData() throws {
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "hello")
      .assertStatus(is: .ok)
      .assertJSON("hello", equals: "world")
  }

  func testThatRequestToPlainTextReturnsProperData() throws {
    try drop
      .clientAuthorizedTestResponse(to: .get, at: "plaintext")
      .assertStatus(is: .ok)
      .assertBody(contains: "Hello, world!")
  }
}
