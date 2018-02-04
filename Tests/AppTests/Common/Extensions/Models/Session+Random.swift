import Vapor
import Foundation
@testable import App

extension Session {
  
  convenience init(_ randomlyInitialized: Bool = true, userId: Identifier) {
    if randomlyInitialized {
      self.init(
        userId: userId,
        token:  UUID().uuidString
      )
    } else {
      self.init(
        userId: userId,
        token: ""
      )
    }
  }
  
}
