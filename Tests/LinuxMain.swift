// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
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
extension RegistrationControllerTests {
  static var allTests: [(String, (RegistrationControllerTests) -> () throws -> Void)] = [
   ("testThatRegFormGetNotFoundForWrongEventId", testThatRegFormGetNotFoundForWrongEventId),
   ("testThatRegFormGetBadReguestForBadEventId", testThatRegFormGetBadReguestForBadEventId),
   ("testThatRegFormHasExpectedFields", testThatRegFormHasExpectedFields),
   ("testThatRegFieldLinkedWithRegFormAndHasExpectedFields", testThatRegFieldLinkedWithRegFormAndHasExpectedFields),
   ("testThatRegFieldAnswerLinkedWithRegFieldAndHasExpectedFields", testThatRegFieldAnswerLinkedWithRegFieldAndHasExpectedFields),
   ("testThatRegFormFetchedByEventId", testThatRegFormFetchedByEventId),
   ("testThatUserRegFormAnswersStoredForEvent", testThatUserRegFormAnswersStoredForEvent),
   ("testThatUserRegFormAnswersStoredForEventOnlyOnce", testThatUserRegFormAnswersStoredForEventOnlyOnce),
   ("testThatIfRegFieldTypeIsRadioThenThereIsOnlyOneAnswer", testThatIfRegFieldTypeIsRadioThenThereIsOnlyOneAnswer),
   ("testThatIfRegFieldIsRequiredThenThereIsAtLeastOneAnswer", testThatIfRegFieldIsRequiredThenThereIsAtLeastOneAnswer),
   ("testThatUserHasAutoapproveIfHave2VisitAndDidNotAppearLessThan2In6Months", testThatUserHasAutoapproveIfHave2VisitAndDidNotAppearLessThan2In6Months)
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

XCTMain([
  testCase(ClientMiddlewareTests.allTests),
  testCase(HeartbeatControllerTests.allTests),
  testCase(RegistrationControllerTests.allTests),
  testCase(RouteTests.allTests)
])
#endif
