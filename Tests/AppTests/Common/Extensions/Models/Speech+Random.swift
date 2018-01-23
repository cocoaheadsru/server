import Vapor
@testable import App

extension Speech {
  
  convenience init(_ randomlyInitialized: Bool = true, eventId: Identifier) {
    if randomlyInitialized {
      self.init(
        eventId: eventId,
        title: String.randomValue,
        description: String.randomValue)
    } else {
      self.init(
        eventId: eventId,
        title: "",
        description: "")
    }
  }
  
}
