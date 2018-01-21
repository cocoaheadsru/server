import Vapor
@testable import App

extension RegForm {
  
  convenience init(_ randomInit: Bool = true, eventId: Identifier) {
    if randomInit {
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
