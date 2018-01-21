import Foundation
import Vapor
import Fluent

final class  AutoapproveController {
  
  private let autoapprove: Approve
  
  init() throws {
    guard let count = try? Approve.count() else {
      fatalError()
    }
    
    if count < 1 {
      autoapprove = Approve(
        visits: 2,
        notAppears: 2,
        appearMonths: 6)
      try autoapprove.save()
    } else {
      autoapprove = try Approve.all().first!
    }
  }
  
  func grandApprove(to user: User, on event: Event) throws -> Bool? {
    
   let visits = try EventReg
    .makeQuery()
    .filter(EventReg.Keys.userId, user.id!)
    .filter(EventReg.Keys.status, EventReg.RegistrationStatus.approved.string)
    .count()
    
    guard  visits >= autoapprove.visits else {
      return false
    }
    
    guard
      let date = Calendar.current.date(byAdding: .month, value: -autoapprove.appearMonths, to: Date())
    else {
        return nil
    }
    
    let events = try Event.makeQuery()
      .filter(Event.Keys.id != event.id! )
      .filter(Event.Keys.endDate >= date)
      .filter(Event.Keys.endDate < Date())
      .all()
    
    let regForms = try RegForm.makeQuery()
      .filter(RegForm.Keys.eventId, in: events.array.map { $0.id! })
      .all()
    
    guard regForms.count >= autoapprove.notAppears else {
      return true
    }
    
    let notAppeareds = try EventReg
      .makeQuery()
      .filter(EventReg.Keys.regFormId, in: regForms.array.map { $0.id!.int })
      .filter(EventReg.Keys.userId, user.id!)
      .filter(EventReg.Keys.status, EventReg.RegistrationStatus.notAppeared.string)
      .count()
    
    guard notAppeareds >= autoapprove.notAppears else {
      return true
    }
    
    return false
  }
  
}
