import Vapor
@testable import App

extension App.Event {
  
  convenience init(_ randomInit: Bool = true, endDate: Int? = nil, placeId: Identifier) {
    
    if randomInit {
      
      var date = Int(Date().timeIntervalSince1970)
      
      if endDate != nil {
        date = endDate!
      }
    
      self.init(
        title: String.randomValue,
        description: String.randomValue,
        photoUrl: String.randomValue,
        placeId: placeId,
        startDate: date,
        endDate: date
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
