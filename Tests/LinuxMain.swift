// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

#if os(Linux)
import XCTest

extension PostControllerTests {
  static var allTests: [(String, (PostControllerTests) -> () throws -> Void)] = [
   ("testPostRoutes", testPostRoutes)
  ]
}
extension RouteTests {
  static var allTests: [(String, (RouteTests) -> () throws -> Void)] = [
   ("testHello", testHello),
   ("testInfo", testInfo)
  ]
}

// swiftlint:disable trailing_comma
XCTMain([
  testCase(PostControllerTests.allTests),
  testCase(RouteTests.allTests)
])
// swiftlint:enable trailing_comma
#endif
