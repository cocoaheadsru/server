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
    
    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]
    
    let res = try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .ok)
    
    guard let eventRegId = try res.json?.get("id") as Int! else {
      XCTFail("Can't get eventRegId from 'event/register' response")
      return
    }
    
    let delres = try drop
      .userAuthorizedTestResponse(
        to: .delete,
        at: "event/register/\(eventRegId)",
        headers: headers)
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "Can't find approved User's registraion for cancel")
    
    let json = delres.json!
    
    print("***** \n\n\(try! json.serialize(prettyPrint: true).makeString())\n\n *****")
    
  }
  
  func testThatTheUserReceivesErrorWhenAttemptingToCancelNotHisRegistration() throws {
    
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
    
    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]
    
    let res = try drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .ok)
    
    guard let eventRegId = try res.json?.get("id") as Int! else {
      XCTFail("Can't get eventRegId from 'event/register' response")
      return
    }
    
    let wrongToken = try getWrongToken(rightToken: userAnswers.sessionToken)!
    
    let headersWithWrongToken: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: wrongToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]
    
    let delres = try drop
      .userAuthorizedTestResponse(
        to: .delete,
        at: "event/register/\(eventRegId)",
        headers: headersWithWrongToken)
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "Can't find approved User's registraion for cancel")
    
    let json = delres.json!
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
    
    let headers: [HeaderKey: String] = [
      TestConstants.Header.Key.userToken: userAnswers.sessionToken,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.applicationJson
    ]
    
    let res = try! drop
      .userAuthorizedTestResponse(
        to: .post,
        at: "event/register",
        headers: headers,
        body: userAnswers.body)
      .assertStatus(is: .ok)
    
    guard let eventRegId = try res.json?.get("id") as Int! else {
      XCTFail("Can't get eventRegId from 'event/register' response")
      return
    }
    
     try! drop
      .userAuthorizedTestResponse(
        to: .delete,
        at: "event/register/\(eventRegId)",
        headers: headers)
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
  
}
