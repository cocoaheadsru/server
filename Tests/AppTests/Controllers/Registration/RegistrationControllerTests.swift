import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

class RegistrationControllerTests: TestCase {
  ///swiftlint:disable force_try
  var drop: Droplet! //= try! Droplet.testable()
  ///swiftlint:enable force_try
  
  override func setUp() {
    super.setUp()
    do {
      try clean()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }
  
  func testThatRegFormGetNotFoundForWrongEventId() throws {
    let wrongEventId = -1
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .ok)
      .assertJSON("message", contains: "ERROR: Can't find RegForm by event_id:")
  }
  
  func testThatRegFormGetBadReguestForBadEventId() throws {
    let wrongEventId = "1,3"
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .badRequest)
      .assertJSON("message", contains: "ERROR: EventId parameters is missing in URL request")
  }
  
  func testThatRegFieldsGetNotFoundMessageForEmptyRegFieldTable() throws {
    //arrange
    guard let eventId = try RegFormHelper.store()?.id else {
      XCTFail("Can't store RegFrom and get event_id")
      return
    }
    
    try drop
      //act
      .userAuthorizedTestResponse(to: .get, at: "event/\(eventId.int ?? 0)/form")
      //assert
      .assertStatus(is: .ok)
      .assertJSON("message", contains: "ERROR: Can't find RegFields by event_id:")
  }
  
  func testThatRegFormAndRegFieldsFetchedByEventId() throws {
    //arrange
    guard let eventId = try EventRegFieldsHelper.store()?.id else {
      XCTFail("Can't store RegFiedld and get event_id")
      return
    }
    
    guard let eventRegFields = try EventRegFieldsHelper.fetchRegFieldsByEventId(eventId) else {
        XCTFail("Can't fetch RegField by event_id: \(eventId)")
        return
    }
    
    guard let regForm = try RegFormHelper.fetchRegFormByEventId(eventId) else {
      XCTFail("Can't fetch RegForm by event_id: \(eventId)")
      return
    }

    let expected = try eventRegFields.makeResponse().json!
    let exp: JSON = try expected.get("reg_fields")
   
    try drop
      //act
      .userAuthorizedTestResponse(to: .get, at: "event/\(eventId.int ?? 0)/form")
      //assert
      .assertStatus(is: .ok)
      .assertJSON("form_name", equals: regForm.formName)
      .assertJSON("reg_fields", equals: exp )
  }

  func testThatUserRegFormAnswersGetNotFoundForWrongEventId() throws {
    let wrongEventId = -1
    try drop
      .userAuthorizedTestResponse(to: .post, at: "event/\(wrongEventId)/register")
      .assertStatus(is: .ok)
      .assertJSON("message", contains: "ERROR: Can't find RegForm by event_id")
  }
  
  func testThatUserRegFormAnswersGetBadReguestForBadEventId() throws {
    let wrongEventId = "1,3"
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/register")
      .assertStatus(is: .badRequest)
      .assertJSON("message", contains: "ERROR: EventId parameters is missing in URL request")
  }
  
  func testThatUserRegFormAnswersSavedForEventId() throws {
  
    guard
      let event = try EventRegAnswerHelper.store(),
      let eventId = event.id
      else {
      XCTFail("Can't store RegFiedld and get event_id")
      return
    }
    
    guard let userAnswers = try EventRegAnswerHelper.getUserAnswers(for: event) else {
      XCTFail("Can't get user answer")
      return
    }
    
    try drop
      .unauthorizedTestResponse(
        to: .post,
        at: "event/\(eventId.int!)/register",
        headers:  [TestConstants.Header.Key.userToken: userAnswers.sessionToken],
        body: userAnswers.body)
      .assertStatus(is: .ok)
    
    guard let storedAnswers = try EventRegAnswerHelper.getStoredAnswers(by: userAnswers.sessionToken, eventId: eventId) else {
      XCTFail("Can't get stored user answer")
      return
    }
    
    XCTAssertEqual(userAnswers.body, storedAnswers)
  }

}

extension RegistrationControllerTests {
  func clean() throws {
    drop = try Droplet.testable()
  }
}
