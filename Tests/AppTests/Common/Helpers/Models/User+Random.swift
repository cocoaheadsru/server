import Vapor
@testable import App

extension User {
  
  convenience init(_ randomInit: Bool = true) {
    if randomInit {
      self.init(
        name: String.randomValue,
        lastname: String.randomValue,
        company: String.randomValue,
        position: String.randomValue,
        photo: "http://\(String.randomValue).png",
        email: "\(String.randomValue)@\(String.randomValue).com",
        //swiftlint:disable line_length
        phone: "+\(Int.randomValue(min: 1, max: 99))-(\(Int.randomValue(min: 100, max: 999)))-\(Int.randomValue(min: 100, max: 999))-\(Int.randomValue(min: 1000, max: 9999))"
        //swiftlint:enable line_length
      )
    } else {
      self.init(
        name: "",
        lastname: "",
        company: "",
        position: "",
        photo: "",
        email: "",
        phone: ""
      )
    }
  }
  
}
