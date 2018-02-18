import Vapor
@testable import App

extension Creator {

  convenience init(_ randomlyInitialized: Bool = true, userId: Identifier) {
    if randomlyInitialized {
      self.init(
        userId: userId,
        position: Int.randomValue,
        photoUrl: String.randomValue,
        info: String.randomValue,
        url: String.randomValue,
        active: Bool.randomValue
      )
    } else {
      self.init(
        userId: userId,
        position: 0,
        photoUrl: "",
        info: "",
        url: "",
        active: true
      )
    }
  }

}
