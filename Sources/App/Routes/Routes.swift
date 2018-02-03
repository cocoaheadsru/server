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
    try resource("event", EventController.self)
    try resource("event/:id/speech", EventSpeechController.self)
    try resource("event/:id/form", RegistrationFormController.self)
    try resource("event/register", RegistrationController.self)
    
    let userController = UserController(droplet: self)
    resource("user", userController)
    try resource("user", UserUnauthorizedController.self)
  }
}
