import Foundation
import Vapor
import Fluent


final class  AutoapproveController {
  
  private let autoapprove: Autoapprove
  
  init() throws {
    guard let count = try? Autoapprove.count() else {
      fatalError()
    }
    
    if count < 1 {
      autoapprove = Autoapprove(
        visits: 2,
        notAppears: 2,
        appearMonths: 6)
      try autoapprove.save()
    } else {
      autoapprove = try Autoapprove.all().first!
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
      let date = Calendar.current
        .date(byAdding: .month, value: -autoapprove.appearMonths, to: Date())?
        .timeIntervalSince1970
    else {
        return nil
    }
    let dateInt = Int(date)
    
    let events = try Event.makeQuery()
      .filter(Event.Keys.id != event.id! )
      .filter(Event.Keys.endDate >= dateInt)
      .filter(Event.Keys.endDate < Date().timeIntervalSince1970)
      .all()
    
    let regForms = try RegForm.makeQuery()
      .filter(RegForm.Keys.eventId, in: events.array.map{ event in return event.id! })
      .all()
    
    guard regForms.count >= autoapprove.notAppears else {
      return true
    }
    
    let notAppeareds = try EventReg
      .makeQuery()
      .filter(EventReg.Keys.regFormId, in: regForms.array.map{
        regForm in return regForm.id!.int
      })
      .filter(EventReg.Keys.userId, user.id!)
      .filter(EventReg.Keys.status, EventReg.RegistrationStatus.notAppeared.string)
      .count()
    
    guard notAppeareds >= autoapprove.notAppears else {
      return true
    }
    
    return false 
  }
  
}
