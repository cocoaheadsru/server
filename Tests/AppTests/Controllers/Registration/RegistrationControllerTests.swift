import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

class RegistrationControllerTests: TestCase {
  //swiftlint:disable force_try
  let drop = try! Droplet.testable()
  //swiftlint:enable force_try
  let controller = RegistrationController()
  
  override func setUp() {
    super.setUp()
    try? clean()
  }
  
  func testThatRegFormGetNotFoundForWrongEventId() throws {
    let wrongEventId = -1
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .notFound)
      .assertJSON("message", contains: "Can't find RegForm by event_id:")
  }
  
  func testThatRegFormGetBadReguestForBadEventId() throws {
    let wrongEventId = "1,3"
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .badRequest)
      .assertJSON("message", contains: "EventId parameters is missing in URL request")
  }
  
  func testThatRegFieldsGetNotFoundMessageForEmptyRegFieldTable() throws {
    //arrange
    guard let eventId = try RegFormHelper.store() else {
      XCTFail("Can't store RegFrom and get event_id")
      return
    }
    
    try drop
      //act
      .userAuthorizedTestResponse(to: .get, at: "event/\(eventId.int ?? 0)/form")
      //assert
      .assertStatus(is: .notFound)
      .assertJSON("message", contains: "Can't find RegFields by event_id:")
  }
  
  func testThatRegFormAndRegFieldsFetchedByEventId() throws {
    //arrange
    guard let eventId = try EventRegFieldsHelper.store() else {
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
}

extension RegistrationControllerTests {
  func clean() throws {
    try Pivot<RegField, Rule>.makeQuery().delete()
    try RegFieldAnswer.makeQuery().delete()
    try RegField.makeQuery().delete()
    try Rule.makeQuery().delete()
    try RegForm.makeQuery().delete()
    try Event.makeQuery().delete()
    try Place.makeQuery().delete()
    try City.makeQuery().delete()
  }
}
