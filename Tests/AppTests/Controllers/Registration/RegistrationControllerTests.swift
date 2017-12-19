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
      .userAuthorizedTestResponse(to: .get, at: endpointWithEventId(wrongEventId))
      .assertStatus(is: .notFound)
  }
  
  func testThatRegFormGetBedReguestForBadId() throws  {
    let wrongEventId = "1,3"
    try drop
      .userAuthorizedTestResponse(to: .get, at: "event/\(wrongEventId)/form")
      .assertStatus(is: .badRequest)
  }
  
  
  func testThatReqFormNameFetchedByEventId() throws {
    //prepare
    let formName = "Форма для HH"
    try clearAll()
    let eventId = try saveFromRegReturnEventId(formName).int ?? 0
    let endpoint = "event/\(eventId)/form"
    try drop
    //act
      .userAuthorizedTestResponse(to: .get, at: endpoint)
    //assert
      .assertStatus(is: .ok)
      .assertJSON("form_name", equals: formName)
  }
  
  
}

extension RegistrationControllerTests {
  
  func endpointWithEventId(_ eventId: Int) -> String {
    return "event/\(eventId)/form"
  }
  
  func clearAll() throws {
    try RegForm.makeQuery().delete()
    //try Event.makeQuery().delete()
    //try Place.makeQuery().delete()
    //try City.makeQuery().delete()
  }
  
  func addCity(_ city : String) throws -> Identifier {
    let city = City(cityName: city)
    try city.save()
    return city.id!
  }
  
  func addPlace() throws -> Identifier {
    let cityId = try addCity("Москва " + String.invalidRandomToken)
    let place = Place(
      title: "HeadHunter",
      address: "ул. Годовикова, 9, стр. 4",
      description: "",
      latitude: 55.809414,
      longitude: 37.6261933,
      cityId: cityId)
    try place.save()
    return place.id!
  }
  
  func addEvent() throws -> Identifier {
    let placeId = try addPlace()
    let event = Event(
      title: "CocoaHeads в HeadHunter",
      description: "Наша следующая встреча пройдёт в офисе компании HeadHunter. Это будет интересный формат, включающий техтолки, три доклада и викторину. Количество мест крайне мало, поэтому в качестве регистрации предлагаем небольшую викторину из трёх вопросов.",
      photoUrl: "",
      placeId: placeId,
      startDate: 1508515200,
      endDate: 1508526000
    )
    try event.save()
    return event.id!
  }
  
  func saveFromRegReturnEventId(_ fromName: String) throws -> Identifier {
    
    let eventId = try addEvent()
    let regForm = RegForm(
      eventId: eventId,
      formName: fromName,
      description: "")
    
    try regForm.save()
    return eventId
  }
  
}
