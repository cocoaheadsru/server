import Vapor
import Fluent
@testable import App
// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
final class UserSessionHelper {
 
  static func store() throws {
    
    for _ in 1...Int.random(min: 2, max: 10) {
      
      let user = User()
      try! user.save()
      user.createSession()

    }
  }
  
}
