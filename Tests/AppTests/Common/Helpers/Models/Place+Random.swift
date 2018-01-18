import Vapor
@testable import App

extension Place {
  
  convenience init(_ randomInit: Bool = true, cityId: Identifier) {
    if randomInit {
      self.init(
        title: String.randomValue,
        address: String.randomValue,
        description: String.randomValue,
        latitude: Double.randomValue,
        longitude: Double.randomValue,
        cityId: cityId
      )
    } else {
      self.init(
        title: "",
        address: "",
        description: "",
        latitude: 0.0,
        longitude: 0.0,
        cityId: cityId
      )
    }
  }
  
}
