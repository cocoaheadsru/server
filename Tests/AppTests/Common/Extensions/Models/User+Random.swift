import Vapor
@testable import App

extension User {
  
  convenience init(_ randomlyInitialized: Bool = true) {
    if randomlyInitialized {
      self.init(
        name: String.randomValue,
        lastname: String.randomValue,
        company: String.randomValue,
        position: String.randomValue,
        photo: String.randomPhotoName,
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
