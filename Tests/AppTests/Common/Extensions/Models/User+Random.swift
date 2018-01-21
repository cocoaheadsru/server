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
        photo: String.randomPhotoURL,
        email: String.randomEmail,
        phone: String.randomPhone
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
