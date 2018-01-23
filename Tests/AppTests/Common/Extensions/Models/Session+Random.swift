import Vapor
import Foundation
@testable import App

extension Session {
  
  convenience init(_ randomlyInitialized: Bool = true, userId: Identifier) {
    if randomlyInitialized {
      self.init(
        userId: userId,
        token:  UUID().uuidString,
        timestamp: Int.randomValue(min: 1514917307-31556926, max: 1514917307)
      )
    } else {
      self.init(
        userId: userId,
        token: "",
        timestamp: 0
      )
    }
  }
  
}
