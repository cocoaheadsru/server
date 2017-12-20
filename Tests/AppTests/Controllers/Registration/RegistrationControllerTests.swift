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
  
  func testThatRegFormGetNotFoundForWrongId() throws  {
    let wrongEventId = -1
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .notFound)
  }
  
  func testThatRegFormGetBedReguestForBadId() throws  {
    let wrongEventId = "1,3"
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .badRequest)
  }
  
  func testThatReqFormNameFetchedByEventId() throws {
    try RegFormHelper.clean()
    guard let eventId = try RegFormHelper.store() else {
      XCTFail()
      return
    }
    let endpoint = "event/\(eventId.int ?? 0)/form"
    guard let regForm = try RegFormHelper.fetchRegFormByEventId(eventId) else {
      XCTFail()
      return
    }
    let formName = regForm.formName
    try drop
      //act
      .userAuthorizedTestResponse(to: .get, at: endpoint)
      //assert
      .assertStatus(is: .ok)
      .assertJSON("form_name", equals: formName)
  }
}

