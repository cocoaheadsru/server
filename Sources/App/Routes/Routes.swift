import Vapor
import AuthProvider

extension Droplet {
  func setupRoutes() throws {

    let frontendAPICollection = FrontendAPICollection(drop: self)
    let testAPICollection = TestAPICollection(drop: self)

    try collection(frontendAPICollection)
    try collection(testAPICollection)

  }
}
