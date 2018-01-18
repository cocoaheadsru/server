import Vapor

extension Droplet {
  func setupRoutes() throws {
    get("hello") { _ in
      var json = JSON()
      try json.set("hello", "world")
      return json
    }
    
    get("plaintext") { _ in
      return "Hello, world!"
    }
    
    try resource("heartbeat", HeartbeatController.self)
    try resource("event/:id/form", RegistrationController.self)
    try resource("event/register", RegistrationController.self)
  }
}
