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
 
  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }
    
  func testThatUserRegFormAnswersStoredForEvent() throws {

    let regForm = try! prepareRegFieldAnswers()
    
    guard let userAnswers = try! EventRegAnswerHelper.generateUserAnswers(for: regForm) else {
      XCTFail("Can't get user answer")
      return
    }

   try eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
    .assertStatus(is: .ok)

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

    try! eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
      .assertStatus(is: .ok)

    try! eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
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
    
    try! eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "The answer to field with type radio should be only one")
  }

  func testThatIfRegFieldIsRequiredThenThereIsAtLeastOneAnswer() throws {
   
    let regForm = try! prepareRegFieldAnswers()

    guard let userAnswers = try! EventRegAnswerHelper.generateUserWrongRequiredAnswers(for: regForm) else {
      XCTFail("Can't get user with the empty required fields answers")
      return
    }

   try! eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "The field must have at least one answer")

  }
  
}

extension RegistrationControllerTests {
  
  func prepareRegFieldAnswers() throws -> RegForm {
    guard
      let regForm = try! EventRegAnswerHelper.store()
      else {
        XCTFail("Can't prepare stage to RegFormAnswer")
        fatalError()
    }
    return regForm
  }

  @discardableResult
  func eventRegistration(_ json: JSON, token: String) throws -> Response {
    return try! drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        body: json,
        bearer: token)
  }

  @discardableResult
  func cancellationOfRegistration(_ eventRegId: Int, token: String) throws -> Response {
    return try! drop
      .userAuthorizedTestResponse(
        to: .delete,
        at: "event/register/\(eventRegId)",
        bearer: token)
  }

}
