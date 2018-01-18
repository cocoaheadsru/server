import Vapor
import Fluent
@testable import App

final class UserSessionHelper {
 
  static func store() throws {
    
    for _ in 1...Int.random(min: 2, max: 10) {
      
      let user = User()
      try user.save()
      
      let session = Session(userId: user.id!)
      try session.save()
      
    }
  }
  
}
