import Vapor
@testable import App

extension Speech {
  
  convenience init(_ randomInit: Bool = true, eventId: Identifier) {
    if randomInit {
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
