import Foundation
import Vapor
import Fluent

final class  AutoapproveController {
  
  private let autoapprove: Approval
  
  init() throws {
    guard let count = try? Approval.count() else {
      fatalError("There are problems with call Approve.count()")
    }
    
    if count < 1 {
      autoapprove = Approval(
        visitedEvents: 2,
        skippedEvents: 2,
        periodInMonths: 6)
      try autoapprove.save()
    } else {
      autoapprove = try Approval.all().first!
    }
  }
  
  func grandApprove(to user: User, on event: Event) throws -> Bool? {
    
    guard let userId = user.id else {
      return nil
    }
      
    let visitedEvents = try EventReg
      .makeQuery()
      .filter(EventReg.Keys.userId, userId)
      .filter(EventReg.Keys.status, EventReg.RegistrationStatus.approved.string)
      .count()
    
    guard visitedEvents >= autoapprove.visitedEvents else {
      return false
    }
    
    guard
      let date = Calendar.current.date(byAdding: .month, value: -autoapprove.periodInMonths, to: Date()),
      let eventId = event.id
    else {
        return nil
    }
    
    let events = try Event.makeQuery()
      .filter(Event.Keys.id != eventId)
      .filter(Event.Keys.endDate >= date)
      .filter(Event.Keys.endDate < Date())
      .all()
    
    let regForms = try RegForm.makeQuery()
      .filter(RegForm.Keys.eventId, in: events.array.map { $0.id! })
      .all()
    
    guard regForms.count >= autoapprove.skippedEvents else {
      return true
    }
    
    let skippedEventsCount = try EventReg
      .makeQuery()
      .filter(EventReg.Keys.regFormId, in: regForms.array.map { $0.id!.int })
      .filter(EventReg.Keys.userId, user.id!)
      .filter(EventReg.Keys.status, EventReg.RegistrationStatus.skipped.string)
      .count()
    
    guard skippedEventsCount >= autoapprove.skippedEvents else {
      return true
    }
    
    return false
  }
  
}
