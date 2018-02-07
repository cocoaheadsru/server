import Vapor
import Foundation
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class SocialAuthControllerTestHelper {

  static func getUserSessionToken(by response: JSON) throws -> String? {
    guard
      let userId = response[User.Keys.id]?.int,
      let user = try! User.find(userId),
      let session = try! user.session()
      else {
        return nil
    }

    return session.token
  }
  
}
