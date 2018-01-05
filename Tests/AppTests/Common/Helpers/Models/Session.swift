import Vapor
@testable import App

extension Session {
  
  convenience init(_ randomInit: Bool = true, userId: Identifier) {
    if randomInit {
      self.init(
        userId: userId,
        token: String.randomValue,
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
