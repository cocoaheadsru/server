// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

#if os(Linux)
import XCTest

extension HeartbeatControllerTests {
  static var allTests: [(String, (HeartbeatControllerTests) -> () throws -> Void)] = [
   ("testThatPostSetBeatAnyValue", testThatPostSetBeatAnyValue),
   ("testThatRowCountAfterStoreAlwaysBeEqualOne", testThatRowCountAfterStoreAlwaysBeEqualOne),
   ("testThatShowGet204NoContentForEmptyBeatTable", testThatShowGet204NoContentForEmptyBeatTable),
   ("testThatShowGetCurrentValueIfBeatTableIsNotEmpty", testThatShowGetCurrentValueIfBeatTableIsNotEmpty),
   ("testThatRoutePostMethodShouldSetAnyIntValue", testThatRoutePostMethodShouldSetAnyIntValue),
   ("testThatRouteGet204NoContectForEmptyBeatTable", testThatRouteGet204NoContectForEmptyBeatTable),
   ("testThatRouteGetCurrentValueIfBeatTableIsNotEmpty", testThatRouteGetCurrentValueIfBeatTableIsNotEmpty),
   ("testThatRouteHearbeatScenarioIsCorrect", testThatRouteHearbeatScenarioIsCorrect)
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
  testCase(HeartbeatControllerTests.allTests),
  testCase(RouteTests.allTests)
])
// swiftlint:enable trailing_comma
#endif
