import Vapor
@testable import App

extension App.Event {
  
  convenience init(_ randomInit: Bool = true, endDate: Date? = nil, placeId: Identifier) {
    var date = Date()
    
    if randomInit {
      
      if endDate != nil {
        date = endDate!
      }

      self.init(
        title: String.randomValue,
        description: String.randomValue,
        photoUrl: String.randomValue,
        placeId: placeId,
        isRegistrationOpen: Bool.randomValue,
        startDate: date.fiveHoursAgo,
        endDate: date,
        hide: Bool.randomValue
      )
    } else {
      self.init(
        title: "",
        description: "",
        photoUrl: "",
        placeId: placeId,
        startDate: date.fiveHoursAgo,
        endDate: date
      )
    }
  }
  
}
