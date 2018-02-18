import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App
// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try

class AutoapproveTest: TestCase {

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }
  
  static let approveRules = ApproveRules(visitedEvents: 2, skippedEvents: 2, periodInMonths: 6)
  
  func testThatUserHasAutoapproveIfHaveEnoughVisitsAndDidNotAppearLessThanNeedsWithinPeriod() throws {
    
    try! EventRegHelper.store()
    guard let userToken = try! EventRegHelper.generateUserForGrantApprove(AutoapproveTest.approveRules) else {
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
    
    try eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
      .assertStatus(is: .ok)
    
    XCTAssertTrue(try EventRegHelper.userIsApproved(with: userAnswers.sessionToken, for: regForm))
    
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
  
  func testThatUserDontGetApproveIfNotHasEnoughVisits() throws {
    
    try! EventRegHelper.store()
    guard let userToken = try! EventRegHelper.generateUserWithNotEnoughVisits(AutoapproveTest.approveRules) else {
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
    
    try eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
      .assertStatus(is: .ok)
    
    XCTAssertFalse(try EventRegHelper.userIsApproved(with: userAnswers.sessionToken, for: regForm))
    
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
  
  func testThatUserDontGetApproveIfHasManyOmissions() throws {
    
    try! EventRegHelper.store()
    guard let userToken = try! EventRegHelper.generateUserWithManyOmissions(AutoapproveTest.approveRules) else {
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
    
    try eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
      .assertStatus(is: .ok)
    
    XCTAssertFalse(try EventRegHelper.userIsApproved(with: userAnswers.sessionToken, for: regForm))
    
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
  
}

extension AutoapproveTest {

  @discardableResult
  func eventRegistration(_ json: JSON, token: String) throws -> Response {
    return try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        body: json,
        bearer: token)
  }

  @discardableResult
  func cancellationOfRegistration(_ eventRegId: Int, token: String) throws -> Response {
    return try drop
      .userAuthorizedTestResponse(
        to: .delete,
        at: "event/register/\(eventRegId)",
        bearer: token)
  }

}
