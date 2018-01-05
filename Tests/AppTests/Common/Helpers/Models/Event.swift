import Vapor
@testable import App

extension App.Event {
  
  convenience init(_ randomInit: Bool = true, placeId: Identifier) {
    if randomInit {
      self.init(
        title: String.randomValue,
        description: String.randomValue,
        photoUrl: String.randomValue,
        placeId: placeId,
        startDate: Int.randomValue,
        endDate: Int.randomValue
      )
    } else {
      self.init(
        title: "",
        description: "",
        photoUrl: "",
        placeId: placeId,
        startDate: 0,
        endDate: 0
      )
    }
  }
  
}
