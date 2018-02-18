import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
class CancelRegistrationTest: TestCase {

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatCancelRegistrationGetErrorForNotApprovedUser() throws {
    
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

    let response = try eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
      .assertStatus(is: .ok)
    
    guard let eventRegId = try response.json?.get("id") as Int! else {
      XCTFail("Can't get eventRegId from 'event/register' response")
      return
    }
    
    let deleteResponse = try cancellationOfRegistration(eventRegId, token: userAnswers.sessionToken)
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "Can't find approved User's registraion for cancel")
    
    let json = deleteResponse.json!
    
    print("***** \n\n\(try! json.serialize(prettyPrint: true).makeString())\n\n *****")
    
  }
  
  func testThatTheUserReceivesErrorWhenAttemptingToCancelNotSelfRegistration() throws {
    
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
    
    let response = try eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
      .assertStatus(is: .ok)
    
    guard let eventRegId = try response.json?.get("id") as Int! else {
      XCTFail("Can't get eventRegId from 'event/register' response")
      return
    }
    
    let wrongToken = try getWrongToken(rightToken: userAnswers.sessionToken)!

    let deleteResponse = try cancellationOfRegistration(eventRegId, token: wrongToken)
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "Can't find approved User's registraion for cancel")
    
    let json = deleteResponse.json!
    print("***** \n\n\(try! json.serialize(prettyPrint: true).makeString())\n\n *****")
    
  }
 
  func testThatCancelRegistrationIsDone() throws {
    
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

    let response = try eventRegistration(userAnswers.body, token: userAnswers.sessionToken)
      .assertStatus(is: .ok)
    
    guard let eventRegId = try response.json?.get("id") as Int! else {
      XCTFail("Can't get eventRegId from 'event/register' response")
      return
    }
    
     try cancellationOfRegistration(eventRegId, token: userAnswers.sessionToken)
      .assertStatus(is: .ok)
    
    let countEvenRegAnsewer = try EventRegAnswer.makeQuery()
      .filter(EventRegAnswer.Keys.eventRegId, eventRegId)
      .all()
      .count
      
    XCTAssertTrue(countEvenRegAnsewer == 0)
    
    let countEventReg  = try EventReg.makeQuery()
      .filter(EventReg.Keys.id, eventRegId)
      .all()
      .count
     XCTAssertTrue(countEventReg == 0)
  }
  
}

extension CancelRegistrationTest {
  
  func getWrongToken(rightToken: String ) throws -> String? {
    guard
      let wrongToken  = try! Session.makeQuery()
        .filter(Session.Keys.token != rightToken)
        .first()?.token
      else {
        XCTFail("Can't get a wrong token")
        return nil
    }
    return wrongToken
  }

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
