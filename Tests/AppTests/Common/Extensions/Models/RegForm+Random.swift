import Vapor
@testable import App

extension RegForm {
  
  convenience init(_ randomlyInitialized: Bool = true, eventId: Identifier) {
    if randomlyInitialized {
      self.init(
        eventId: eventId,
        formName: String.randomValue,
        description: String.randomValue
      )
    } else {
      self.init(
        eventId: eventId,
        formName: "",
        description: ""
      )
    }
  }
  
}
