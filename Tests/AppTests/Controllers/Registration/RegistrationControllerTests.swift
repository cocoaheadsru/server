import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
class RegistrationControllerTests: TestCase {
 
  var drop: Droplet!
  
  override func setUp() {
    super.setUp()
    do {
      drop = try Droplet.testable()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }
  
  // MARK: - Registration Form building
  
  func testThatRegFormGetNotFoundForWrongEventId() throws {
    let wrongEventId = -1
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "Can't find RegForm by event_id:")
  }
  
  func testThatRegFormGetBadReguestForBadEventId() throws {
    let wrongEventId = "1,3"
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .badRequest)
      .assertJSON("reason", contains: "EventId parameters is missing in URL request")
  }

  func testThatRegFormHasExpectedFields() throws {
    guard let regForm = try! RegFormHelper.store()?.first else {
      XCTFail("Can't get RegForms")
      return
    }
    XCTAssertTrue(try RegFormHelper.assertRegFromHasExpectedFields(regForm.makeJSON()))
  }
  
  func testThatRegFieldLinkedWithRegFormAndHasExpectedFields() throws {
    guard let regForms = try! RegFormHelper.store() else {
      XCTFail("Can't get RegForms")
      return
    }
    
    guard let regField = try! RegFieldHelper.store(for: regForms)?.first else {
      XCTFail("Can't get RegField")
      return
    }
    
    XCTAssertTrue(try RegFieldHelper.assertRegFieldHasExpectedFields(regField.makeJSON()))
  }
  
  func testThatRegFieldAnswerLinkedWithRegFieldAndHasExpectedFields() throws {
    guard let regForms = try! RegFormHelper.store() else {
      XCTFail("Can't get RegForms")
      return
    }
    
    guard let regFields = try! RegFieldHelper.store(for: regForms) else {
      XCTFail("Can't get RegFields")
      return
    }
    
    guard let regFiedAnswer = try! RegFieldAnswerHelper.store(for: regFields)?.first else {
      XCTFail("Can't get RegFiedAnswer")
      return
    }
    
    XCTAssertTrue(try RegFieldAnswerHelper.assertRegFieldAnswerHasExpectedFields(regFiedAnswer.makeJSON()))
  }
  
  func testThatRegFormFetchedByEventId() throws {
    //arrange
    
    guard let regForm = try! RegFormHelper.store()?.random else {
      XCTFail("Can't get RegForms")
      return
    }
  
    guard let regFields = try! RegFieldHelper.store(for: [regForm]) else {
      XCTFail("Can't get RegFields")
      return
    }
    
    guard try! RegFieldAnswerHelper.store(for: regFields) != nil else {
      XCTFail("Can't get RegFiedAnswer")
      return
    }
    
    guard let eventId = regForm.eventId.int else {
      XCTFail("Can't get eventId for RegForm with id \(regForm.id?.int ?? -1)")
      return
    }
    
    let expected = try regForm.makeResponse().json!

    try! drop
      //act
      .userAuthorizedTestResponse(to: .get, at: "event/\(eventId)/form")
      //assert
      .assertStatus(is: .ok)
      .assertJSON("", equals: expected)
  }

  // MARK: - User's registaion answer handle
  
  func testThatUserRegFormAnswersStoredForEvent() throws {

    let regForm = try! prepareRegFieldAnswers()
    
    guard let userAnswers = try EventRegAnswerHelper.generateUserAnswers(for: regForm) else {
      XCTFail("Can't get user answer")
      return
    }

    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]

    try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .ok)
      .assertJSON("message", contains: "OK: stored")

    guard let storedAnswers = try EventRegAnswerHelper.getStoredAnswers(by: userAnswers.sessionToken, regForm: regForm) else {
      XCTFail("Can't get stored user answers")
      return
    }

    print("User session-token:\(userAnswers.sessionToken)")
    print("*** EXPECTED JSON ***")
    print(try userAnswers.body.serialize(prettyPrint: true).makeString())
    print("*** STORED JSON ***")
    print(try storedAnswers.serialize(prettyPrint: true).makeString())

    XCTAssertEqual(userAnswers.body, storedAnswers)
  }

  func testThatUserRegFormAnswersStoredForEventOnlyOnce() throws {
    
    let regForm = try! prepareRegFieldAnswers()

    guard let userAnswers = try! EventRegAnswerHelper.generateUserAnswers(for: regForm) else {
      XCTFail("Can't get user answers")
      return
    }

    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]

    try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .ok)
      .assertJSON("message", contains: "OK: stored")

    try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "User with token '\(userAnswers.sessionToken)' has alredy registered to this event")

    print("User session-token:\(userAnswers.sessionToken)")
    print("*** EXPECTED JSON ***")
    print(try userAnswers.body.serialize(prettyPrint: true).makeString())
  }

  func testThatIfRegFieldTypeIsRadioThenThereIsOnlyOneAnswer() throws {
    let regForm = try! prepareRegFieldAnswers()

    guard let userAnswers = try EventRegAnswerHelper.generateUserWrongRadioAnswers(for: regForm) else {
      XCTFail("Can't get user with wrong radio answers")
      return
    }

    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]

    try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "The answer to field with type radio should be only one")
  }

  func testThatIfRegFieldIsRequiredThenThereIsAtLeastOneAnswer() throws {
   
    let regForm = try! prepareRegFieldAnswers()

    guard let userAnswers = try! EventRegAnswerHelper.generateUserWrongRequiredAnswers(for: regForm) else {
      XCTFail("Can't get user with the empty required fields answers")
      return
    }

    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]

    try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "The field must have at least one answer")

  }
  
  // MARK: - Autoapprove
  
  static let approveRules: ApproveRules = (visits: 2, notAppears: 2, appearMonths: 6)
  
  func testThatUserHasAutoapproveIfHaveEnoughVisitsAndDidNotAppearLessThanNeedsWithinPeriod() throws {
    
    try! EventRegHelper.store()
    guard let userToken = try! EventRegHelper.generateUserForGrantApprove(RegistrationControllerTests.approveRules) else {
      XCTFail("Can't generateUserForGrantAutoapprove")
      return
    }

    guard let regForm = try! EventRegHelper.generateNewEventAndRegForm() else {
      XCTFail("Can't get regForm for new event")
      return
    }
    
    guard let userAnswers = try! EventRegAnswerHelper.generateUserAnswers(with: userToken, for: regForm) else {
      XCTFail("Can't get user with the empty required fields answers")
      return
    }
    
    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]
    
    try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .ok)
      .assertJSON("message", contains: "OK: stored")
    
    XCTAssertTrue(try EventRegHelper.userIsApproved(with: userAnswers.sessionToken, for: regForm))
    
  }
  
  func testThatUserDontGetApproveIfNotHasEnoughVisits() throws {
    
    try! EventRegHelper.store()
    guard let userToken = try! EventRegHelper.generateUserWithNotEnoughVisits(RegistrationControllerTests.approveRules) else {
      XCTFail("Can't generateUserForGrantAutoapprove")
      return
    }
    
    guard let regForm = try! EventRegHelper.generateNewEventAndRegForm() else {
      XCTFail("Can't get regForm for new event")
      return
    }
    
    guard let userAnswers = try! EventRegAnswerHelper.generateUserAnswers(with: userToken, for: regForm) else {
      XCTFail("Can't get user with the empty required fields answers")
      return
    }
    
    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]
    
    try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .ok)
      .assertJSON("message", contains: "OK: stored")
    
    XCTAssertFalse(try EventRegHelper.userIsApproved(with: userAnswers.sessionToken, for: regForm))
    
  }

  func testThatUserDontGetApproveIfHasManyOmissions() throws {
    
    try! EventRegHelper.store()
    guard let userToken = try! EventRegHelper.generateUserWithManyOmissions(RegistrationControllerTests.approveRules) else {
      XCTFail("Can't generateUserForGrantAutoapprove")
      return
    }
    
    guard let regForm = try! EventRegHelper.generateNewEventAndRegForm() else {
      XCTFail("Can't get regForm for new event")
      return
    }
    
    guard let userAnswers = try! EventRegAnswerHelper.generateUserAnswers(with: userToken, for: regForm) else {
      XCTFail("Can't get user with the empty required fields answers")
      return
    }
    
    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]
    
    try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .ok)
      .assertJSON("message", contains: "OK: stored")
    
    XCTAssertFalse(try EventRegHelper.userIsApproved(with: userAnswers.sessionToken, for: regForm))
    
  }
  
// MARK: - Canceled registration
//  func testThatCanceleRegistrationGetNotFoundForWrongEventId() throws {
//    let wrongEventId = -1
//    try drop
//      .userAuthorizedTestResponse(to: .delete, at: "event/\(wrongEventId)/register")
//      .assertStatus(is: .internalServerError)
//      .assertJSON("message", contains: "ERROR: Can't find Registraion by event_id:")
//  }
//
//  func testThatCanceleRegistrationBadReguestForBadEventId() throws {
//    let wrongEventId = "1,3"
//    try drop
//      .userAuthorizedTestResponse(to: .delete, at: "event/\(wrongEventId)/register")
//      .assertStatus(is: .badRequest)
//      .assertJSON("message", contains: "ERROR: EventId parameters is missing in URL request")
//  }
  
}

extension RegistrationControllerTests {
  
  func prepareRegFieldAnswers() throws -> RegForm {
    guard
      let regForm = try EventRegAnswerHelper.store()
      else {
        XCTFail("Can't prepare stage to RegFormAnswer")
        fatalError()
    }
    return regForm
  }

}
