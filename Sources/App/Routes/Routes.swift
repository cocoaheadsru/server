import Vapor

extension Droplet {
  func setupRoutes() throws {
    let users = UserController()
    users.addRoutes(to: self)
    users.addUpdateRoute(to: self)
  }
}
