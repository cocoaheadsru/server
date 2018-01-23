import Vapor
@testable import App

extension City {
  
  convenience init(_ randomlyInitialized: Bool = true) {
    if randomlyInitialized {
      self.init(cityName: String.randomValue)
    } else {
      self.init(cityName: "")
    }
  }
  
}
