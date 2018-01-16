// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

#if os(Linux)
import XCTest

extension ClientMiddlewareTests {
  static var allTests: [(String, (ClientMiddlewareTests) -> () throws -> Void)] = [
   ("testThatMiddlewarePresentInConfig", testThatMiddlewarePresentInConfig),
   ("testThatConfigInitializationFailWithoutToken", testThatConfigInitializationFailWithoutToken),
   ("testThatConfigInitializationFailWithEmptyToken", testThatConfigInitializationFailWithEmptyToken),
   ("testThatFailedConfigInitializationThrowsProperError", testThatFailedConfigInitializationThrowsProperError),
   ("testThatConfigInitializationPassWithAnyNonEmptyToken", testThatConfigInitializationPassWithAnyNonEmptyToken),
   ("testThatTokenIsAssignedFromConfigInitialization", testThatTokenIsAssignedFromConfigInitialization),
   ("testThatResponsePassWithCoincidentToken", testThatResponsePassWithCoincidentToken),
   ("testThatResponseFailWithIncoincidentToken", testThatResponseFailWithIncoincidentToken)
  ]
}
extension EventControllerTests {
  static var allTests: [(String, (EventControllerTests) -> () throws -> Void)] = [
   ("testThatEventHasPlaceRelation", testThatEventHasPlaceRelation),
   ("testThatPlaceOfEventHasCityRelation", testThatPlaceOfEventHasCityRelation),
   ("testThatIndexEventsReturnsOkStatusForBeforeQueryKey", testThatIndexEventsReturnsOkStatusForBeforeQueryKey),
   ("testThatIndexEventsReturnsOkStatusForAfterQueryKey", testThatIndexEventsReturnsOkStatusForAfterQueryKey),
   ("testThatIndexEventsReturnsJSONArray", testThatIndexEventsReturnsJSONArray),
   ("testThatIndexEventsReturnsJSONArrayEventsHasAllRequiredFields", testThatIndexEventsReturnsJSONArrayEventsHasAllRequiredFields),
   ("testThatIndexEventsReturnsJSONArrayEventsHasAllExpectedFields", testThatIndexEventsReturnsJSONArrayEventsHasAllExpectedFields),
   ("testThatIndexEventsReturnsCorrectNumberOfPastEvents", testThatIndexEventsReturnsCorrectNumberOfPastEvents),
   ("testThatIndexEventsReturnsCorrectNumberOfComingEvents", testThatIndexEventsReturnsCorrectNumberOfComingEvents),
   ("testThatIndexEventsReturnsCorrectNumberOfPastAndComingEvents", testThatIndexEventsReturnsCorrectNumberOfPastAndComingEvents),
   ("testThatGetEventsBeforeTimestampRouteReturnsOkStatus", testThatGetEventsBeforeTimestampRouteReturnsOkStatus),
   ("testThatGetEventsAfterTimestampRouteReturnsOkStatus", testThatGetEventsAfterTimestampRouteReturnsOkStatus),
   ("testThatGetEventsRouteFailsForEmptyQueryParameters", testThatGetEventsRouteFailsForEmptyQueryParameters),
   ("testThatGetEventsRouteFailsWithWrongQueryParameterKey", testThatGetEventsRouteFailsWithWrongQueryParameterKey),
   ("testThatGetEventsRouteFailsWithWrongQueryParameterValue", testThatGetEventsRouteFailsWithWrongQueryParameterValue)
  ]
}
extension EventSpeechControllerTests {
  static var allTests: [(String, (EventSpeechControllerTests) -> () throws -> Void)] = [
   ("testThatIndexSpeechesReturnsOkStatus", testThatIndexSpeechesReturnsOkStatus),
   ("testThatIndexSpeechesFailsWithIncorrectParameter", testThatIndexSpeechesFailsWithIncorrectParameter),
   ("testThatIndexSpeechesReturnsJSONWithAllRequiredFields", testThatIndexSpeechesReturnsJSONWithAllRequiredFields),
   ("testThatIndexSpeechesReturnsJSONWithExpectedFields", testThatIndexSpeechesReturnsJSONWithExpectedFields),
   ("testThatIndexSpeechesReturnsCorrectSpeechesCount", testThatIndexSpeechesReturnsCorrectSpeechesCount),
   ("testThatIndexSpeechesReturnsCorrectSpeakersCount", testThatIndexSpeechesReturnsCorrectSpeakersCount),
   ("testThatIndexSpeechesReturnsCorrectContentsCount", testThatIndexSpeechesReturnsCorrectContentsCount),
   ("testThatGetSpeechesRouteReturnsOkStatus", testThatGetSpeechesRouteReturnsOkStatus),
   ("testThatGetSpeechesRouteFailsForEmptyTable", testThatGetSpeechesRouteFailsForEmptyTable),
   ("testThatGetSpeechesRouteFailsWithNonIntParameterValue", testThatGetSpeechesRouteFailsWithNonIntParameterValue)
  ]
}
extension HeartbeatControllerTests {
  static var allTests: [(String, (HeartbeatControllerTests) -> () throws -> Void)] = [
   ("testThatPostSetBeatAnyValue", testThatPostSetBeatAnyValue),
   ("testThatRowCountAfterStoreAlwaysBeEqualOne", testThatRowCountAfterStoreAlwaysBeEqualOne),
   ("testThatShowGet204NoContentForEmptyBeatTable", testThatShowGet204NoContentForEmptyBeatTable),
   ("testThatShowGetCurrentValueIfBeatTableIsNotEmpty", testThatShowGetCurrentValueIfBeatTableIsNotEmpty),
   ("testThatRoutePostMethodShouldSetAnyIntValue", testThatRoutePostMethodShouldSetAnyIntValue),
   ("testThatRouteGet204NoContentForEmptyBeatTable", testThatRouteGet204NoContentForEmptyBeatTable),
   ("testThatRouteGetCurrentValueIfBeatTableIsNotEmpty", testThatRouteGetCurrentValueIfBeatTableIsNotEmpty),
   ("testThatRouteHearbeatScenarioIsCorrect", testThatRouteHearbeatScenarioIsCorrect)
  ]
}
extension RouteTests {
  static var allTests: [(String, (RouteTests) -> () throws -> Void)] = [
   ("testThatRequestWithNoClientTokenFails", testThatRequestWithNoClientTokenFails),
   ("testThatAuthorizedRequestPasses", testThatAuthorizedRequestPasses),
   ("testThatRequestWithInvalidClientTokenFails", testThatRequestWithInvalidClientTokenFails),
   ("testThatRequestToHelloReturnsProperData", testThatRequestToHelloReturnsProperData),
   ("testThatRequestToPlainTextReturnsProperData", testThatRequestToPlainTextReturnsProperData)
  ]
}

// swiftlint:disable trailing_comma
XCTMain([
  testCase(ClientMiddlewareTests.allTests),
  testCase(EventControllerTests.allTests),
  testCase(EventSpeechControllerTests.allTests),
  testCase(HeartbeatControllerTests.allTests),
  testCase(RouteTests.allTests)
])
// swiftlint:enable trailing_comma
#endif
