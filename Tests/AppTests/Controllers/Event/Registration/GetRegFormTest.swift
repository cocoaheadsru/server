import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
class GetRegFormTests: TestCase {
  
  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }
    
  func testThatRegFormGetNotFoundForWrongEventId() throws {
    let wrongEventId = -1
    try drop
      .userAuthorizedTestResponse(to: .get, at: "api/event/\(wrongEventId)/form")
      .assertStatus(is: .internalServerError)
      .assertJSON("reason", contains: "Can't find RegForm by event_id:")
  }
  
  func testThatRegFormGetBadReguestForBadEventId() throws {
    let wrongEventId = "1,3"
    try drop
      .userAuthorizedTestResponse(to: .get, at: "api/event/\(wrongEventId)/form")
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
      .userAuthorizedTestResponse(to: .get, at: "api/event/\(eventId)/form")
      //assert
      .assertStatus(is: .ok)
      .assertJSON("", equals: expected)
  }
  
}
