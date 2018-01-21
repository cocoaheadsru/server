import Vapor
import Foundation
@testable import App

extension Session {
  
  convenience init(_ randomInit: Bool = true, userId: Identifier) {
    if randomInit {
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
