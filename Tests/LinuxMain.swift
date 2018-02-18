// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

#if os(Linux)
import XCTest
@testable import AppTests

extension AutoapproveTest {
  static var allTests: [(String, (AutoapproveTest) -> () throws -> Void)] = [
   ("testThatUserHasAutoapproveIfHaveEnoughVisitsAndDidNotAppearLessThanNeedsWithinPeriod", testThatUserHasAutoapproveIfHaveEnoughVisitsAndDidNotAppearLessThanNeedsWithinPeriod),
   ("testThatUserDontGetApproveIfNotHasEnoughVisits", testThatUserDontGetApproveIfNotHasEnoughVisits),
   ("testThatUserDontGetApproveIfHasManyOmissions", testThatUserDontGetApproveIfHasManyOmissions)
  ]
}
extension CancelRegistrationTest {
  static var allTests: [(String, (CancelRegistrationTest) -> () throws -> Void)] = [
   ("testThatCancelRegistrationGetErrorForNotApprovedUser", testThatCancelRegistrationGetErrorForNotApprovedUser),
   ("testThatTheUserReceivesErrorWhenAttemptingToCancelNotSelfRegistration", testThatTheUserReceivesErrorWhenAttemptingToCancelNotSelfRegistration),
   ("testThatCancelRegistrationIsDone", testThatCancelRegistrationIsDone)
  ]
}
extension ClientMiddlewareTests {
  static var allTests: [(String, (ClientMiddlewareTests) -> () throws -> Void)] = [
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
extension FacebookSocialControllerTest {
  static var allTests: [(String, (FacebookSocialControllerTest) -> () throws -> Void)] = [
   ("testThatUserIsCreatedAndStoredFromFacebookAccount", testThatUserIsCreatedAndStoredFromFacebookAccount),
   ("testThatSessionTokenIsCreatedAndStoredFromFacebookAccount", testThatSessionTokenIsCreatedAndStoredFromFacebookAccount),
   ("testThatIfUserExistThenUserProfileUpdatedFromFacebook", testThatIfUserExistThenUserProfileUpdatedFromFacebook),
   ("testThatUserPhotoFromFacebookIsSaved", testThatUserPhotoFromFacebookIsSaved)
  ]
}
extension GetRegFormTests {
  static var allTests: [(String, (GetRegFormTests) -> () throws -> Void)] = [
   ("testThatRegFormGetNotFoundForWrongEventId", testThatRegFormGetNotFoundForWrongEventId),
   ("testThatRegFormGetBadReguestForBadEventId", testThatRegFormGetBadReguestForBadEventId),
   ("testThatRegFormHasExpectedFields", testThatRegFormHasExpectedFields),
   ("testThatRegFieldLinkedWithRegFormAndHasExpectedFields", testThatRegFieldLinkedWithRegFormAndHasExpectedFields),
   ("testThatRegFieldAnswerLinkedWithRegFieldAndHasExpectedFields", testThatRegFieldAnswerLinkedWithRegFieldAndHasExpectedFields),
   ("testThatRegFormFetchedByEventId", testThatRegFormFetchedByEventId)
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
extension PushNotificationControllerTest {
  static var allTests: [(String, (PushNotificationControllerTest) -> () throws -> Void)] = [
   ("testThatPushTokenIsRegistered", testThatPushTokenIsRegistered),
   ("testThatPushTokenIsRegisteredOnlyOneTimeForCertainUser", testThatPushTokenIsRegisteredOnlyOneTimeForCertainUser),
   ("testThatPushNotificationIsCanceled", testThatPushNotificationIsCanceled)
  ]
}
extension RegistrationControllerTests {
  static var allTests: [(String, (RegistrationControllerTests) -> () throws -> Void)] = [
   ("testThatUserRegFormAnswersStoredForEvent", testThatUserRegFormAnswersStoredForEvent),
   ("testThatUserRegFormAnswersStoredForEventOnlyOnce", testThatUserRegFormAnswersStoredForEventOnlyOnce),
   ("testThatIfRegFieldTypeIsRadioThenThereIsOnlyOneAnswer", testThatIfRegFieldTypeIsRadioThenThereIsOnlyOneAnswer),
   ("testThatIfRegFieldIsRequiredThenThereIsAtLeastOneAnswer", testThatIfRegFieldIsRequiredThenThereIsAtLeastOneAnswer)
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
extension UserAuthByTokenTest {
  static var allTests: [(String, (UserAuthByTokenTest) -> () throws -> Void)] = [
   ("testThatGotUnauthorizedWithEmptyAccessToken", testThatGotUnauthorizedWithEmptyAccessToken),
   ("testThatGotUnauthorizedWithIncorrectAccessToken", testThatGotUnauthorizedWithIncorrectAccessToken),
   ("testThatGotAccessWithCorrectAccessToken", testThatGotAccessWithCorrectAccessToken)
  ]
}
extension UserControllerTests {
  static var allTests: [(String, (UserControllerTests) -> () throws -> Void)] = [
   ("testThatSessionTokenDoesNotUpdateOnEveryShowRequest", testThatSessionTokenDoesNotUpdateOnEveryShowRequest),
   ("testThatShowMethodUpdatesSessionTokenAfterOneMonth", testThatShowMethodUpdatesSessionTokenAfterOneMonth),
   ("testThatUpdateMethodUpdatesUserCredentials", testThatUpdateMethodUpdatesUserCredentials),
   ("testThatUpdateMethodReturnsUpdatedUser", testThatUpdateMethodReturnsUpdatedUser)
  ]
}
extension UserPhotoTest {
  static var allTests: [(String, (UserPhotoTest) -> () throws -> Void)] = [
   ("testThatUserPhotoIsUpdatedByFormDataSend", testThatUserPhotoIsUpdatedByFormDataSend),
   ("testThatUserPhotoIsUpdatedByPhotoSendAsBase64EncodedString", testThatUserPhotoIsUpdatedByPhotoSendAsBase64EncodedString),
   ("testThatUserPhotoIsUpdatedByPhotoSendAsURL", testThatUserPhotoIsUpdatedByPhotoSendAsURL)
  ]
}
extension VkontakteAuthControllerTest {
  static var allTests: [(String, (VkontakteAuthControllerTest) -> () throws -> Void)] = [
   ("testThatUserCreatedAndStoredFromVkontakteAccount", testThatUserCreatedAndStoredFromVkontakteAccount),
   ("testThatSessionTokenCreatedAndStoredFromVkontakteAccount", testThatSessionTokenCreatedAndStoredFromVkontakteAccount),
   ("testThatIfUserExistThenUserProfileUpdatedFromVkontakte", testThatIfUserExistThenUserProfileUpdatedFromVkontakte),
   ("testThatUserPhotoFromVkontakteIsSaved", testThatUserPhotoFromVkontakteIsSaved)
  ]
}

XCTMain([
  testCase(AutoapproveTest.allTests),
  testCase(CancelRegistrationTest.allTests),
  testCase(ClientMiddlewareTests.allTests),
  testCase(EventControllerTests.allTests),
  testCase(EventSpeechControllerTests.allTests),
  testCase(FacebookSocialControllerTest.allTests),
  testCase(GetRegFormTests.allTests),
  testCase(HeartbeatControllerTests.allTests),
  testCase(PushNotificationControllerTest.allTests),
  testCase(RegistrationControllerTests.allTests),
  testCase(RouteTests.allTests),
  testCase(UserAuthByTokenTest.allTests),
  testCase(UserControllerTests.allTests),
  testCase(UserPhotoTest.allTests),
  testCase(VkontakteAuthControllerTest.allTests)
])
#endif
