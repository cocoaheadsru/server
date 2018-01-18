import Vapor
import Fluent
import Foundation
@testable import App

typealias ApproveRules = (visits: Int, notAppears: Int, appearMonths: Int)

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try

final class EventRegHelper {
  
  static func userIsApproved(with token: String, for regForm: RegForm) throws -> Bool {
    
    guard
      let userId = try! Session.find(by: token)?.user?.id,
      let regFormId = regForm.id,
      let status = try! EventReg.makeQuery()
        .filter(EventReg.Keys.regFormId, regFormId)
        .filter(EventReg.Keys.userId, userId)
        .first()?.status
      else {
        return false
    }
    
    return status == EventReg.RegistrationStatus.approved
  }
  
  static func generateNewEventAndRegForm() throws  -> RegForm? {
    let city = City()
    try! city.save()
    let cityId = city.id!
    
    let place =  Place(cityId: cityId)
    try! place.save()
    let placeId = place.id!
    
    let event = App.Event(placeId: placeId)
    try! event.save()
    let eventId = event.id!
    
    let regForm = RegForm(eventId: eventId)
    try! regForm.save()
    return regForm
  }
  
  @discardableResult
  static func store() throws -> [App.Event]? {
    try! UserSessionHelper.store()
    guard
      let events  = try EventHelper.store(),
      let regForm = try! RegFormHelper.store(for: events),
      let regFields = try! RegFieldHelper.store(for: regForm),
      try! RegFieldAnswerHelper.store(for: regFields) != nil
      else {
        return nil
    }
    return events
  }
  
  static func generateUserWithNotEnoughVisits(_ approveRules: ApproveRules) throws -> SessionToken? {
    var approveRulesWithNoEnoughVisits = approveRules
    approveRulesWithNoEnoughVisits.visits -= 1
    return try generateUserForGrantApprove(approveRulesWithNoEnoughVisits)
  }
  
  static func generateUserWithManyOmissions(_ approveRules: ApproveRules) throws -> SessionToken? {
    var approveRulesWithNoEnoughVisits = approveRules
    approveRulesWithNoEnoughVisits.notAppears += 1
    return try generateUserForGrantApprove(approveRulesWithNoEnoughVisits)
  }
  
  static func generateUserForGrantApprove(_ approveRules: ApproveRules) throws -> SessionToken? {
  
    func fillEventReg(_ event: App.Event, status: EventReg.RegistrationStatus, userId: Identifier, token: String) throws {
     
        guard
          let regForm = try! event.regForm(),
          let regFormId = regForm.id
          else {
            return
        }
        event.isRegistrationOpen = false
        
        try EventRegAnswerHelper.generateUserAnswers(with: token, for: regForm)
        
        let eventReg = EventReg.init(
          regFormId: regFormId,
          userId: userId,
          status: status)
        try eventReg.save()
      
    }
    
    guard
      let session = try! Session.all().random,
      let events = try! App.Event.getMonthsAgo(approveRules.appearMonths)
      else {
        return nil
    }
    
    let token = session.token
    let userId = session.userId
    var shuffledEvents = events.shuffled()
    
    // MARK: - Visit
    for _ in 1...approveRules.visits {
    
      guard let event =  shuffledEvents.popLast() else {
          return nil
      }
      try! fillEventReg(event,
                       status: EventReg.RegistrationStatus.approved,
                       userId: userId,
                       token: token)
    }
  
    // MARK: - Not Appears
    guard approveRules.notAppears > 0 else {
      return token
    }
    
    guard shuffledEvents.count > approveRules.notAppears - 1 else {
      return nil
    }
    
    for i in 1...approveRules.notAppears - 1 {
      try! fillEventReg(shuffledEvents[i],
                        status: EventReg.RegistrationStatus.notAppeared,
                        userId: userId,
                        token: token)
    }
    return token
  }
  
}

extension App.Event {
  
  static func getMonthsAgo(_ months: Int) throws -> [App.Event]? {
    
    guard let date = Calendar.current.date(byAdding: .month, value: -months, to: Date())?.timeIntervalSince1970 else {
      return nil
    }
    let dateInt = Int(date)
    let now = Date().timeIntervalSince1970
    let nowInt = Int(now)
    return try self.makeQuery()
      .filter(Keys.endDate >= dateInt)
      .filter(Keys.endDate <  nowInt)
      .all()
  }
  
}
