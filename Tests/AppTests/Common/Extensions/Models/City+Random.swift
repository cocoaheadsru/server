import Vapor
@testable import App

extension City {
  
  convenience init(_ randomInit: Bool = true) {
    if randomInit {
      self.init(cityName: String.randomValue)
    } else {
      self.init(cityName: "")
    }
  }
  
}
