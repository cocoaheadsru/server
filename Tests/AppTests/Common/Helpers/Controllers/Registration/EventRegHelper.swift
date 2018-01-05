import Foundation

import Vapor
import Fluent
@testable import App

final class EventRegHelper {
  
  static func store() throws -> App.Event? {
    
    guard
      let event = try EventRegFieldsHelper.store(),
      let eventId = event.id,
      let regFormId = try App.Event.find(eventId)?.registrationForm()?.id
    else {
      return nil
    }
        
    for _ in 1...Int.random(min: 2, max: 10) {
      
      let user = User()
      try user.save()
      
      let session = Session(userId: user.id!)
      try session.save()
      
      guard
        
      let userId = user.id else {
        return nil
      }
      
      let enventReg = EventReg(
        regFormId: regFormId,
        userId: userId
      )
      try enventReg.save()
    }
    
    return event
  }
  
}
