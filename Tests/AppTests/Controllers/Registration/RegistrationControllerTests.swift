import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

class RegistrationControllerTests: TestCase {
  
  let drop = try! Droplet.testable()
  let controller = RegistrationController()
  
  override func setUp()  {
      super.setUp()
      try? clean()
  }
  
  func testThatRegFormGetNotFoundForWrongEventId() throws  {
    let wrongEventId = -1
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .notFound)
      .assertJSON("message", contains: "Can't find RegForm by event_id:")
  }
  
  func testThatRegFormGetBadReguestForBadEventId() throws  {
    let wrongEventId = "1,3"
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .badRequest)
      .assertJSON("message", contains: "EventId parameters is missing in URL request")
  }
  
  func testThatRegFieldsGetNotFoundMessage() throws {
    //arrange
    guard let eventId = try RegFormHelper.store() else {
      XCTFail()
      return
    }
    let endpoint = "event/\(eventId.int ?? 0)/form"
    
    try drop
      //act
      .userAuthorizedTestResponse(to: .get, at: endpoint)
      //assert
      .assertStatus(is: .notFound)
      .assertJSON("message", contains: "Can't find RegFields by event_id:")
    
  }
  
  
  func testThatRegFomrAndRegFieldsFetchedByEventId() throws {
    //arrange
    guard let eventId = try EventRegFieldsHelper.store() else {
      XCTFail()
      return
    }
    
    let endpoint = "event/\(eventId.int ?? 0)/form"
    
    guard let eventRegFields = try EventRegFieldsHelper.fetchRegFieldsByEventId(eventId) else {
      XCTFail()
      return
    }
    
    guard let regForm = try RegFormHelper.fetchRegFormByEventId(eventId) else {
      XCTFail()
      return
    }
    
    try drop
      //act
      .userAuthorizedTestResponse(to: .get, at: endpoint)
      //assert
      .assertStatus(is: .ok)
      .assertJSON("form_name", equals: regForm.formName)
      .assertJSON("reg_fields", fuzzyEquals: eventRegFields)
    }
}




extension RegistrationControllerTests {
  func clean() throws {
    try Pivot<RegField, Rule>.makeQuery().delete()
    try EventRegField.makeQuery().delete()
    try RegField.makeQuery().delete()
    try Rule.makeQuery().delete()
    try RegForm.makeQuery().delete()
    try Event.makeQuery().delete()
    try Place.makeQuery().delete()
    try City.makeQuery().delete()
  }
}
