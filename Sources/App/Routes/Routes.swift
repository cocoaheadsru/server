import Vapor

extension Droplet {
  func setupRoutes() throws {
    let clientMiddlewareGroup = self.grouped(try ClientMiddleware(config: config))
    // TODO: add TokenMiddleware
    let userMiddlewareGroup = self.grouped([try ClientMiddleware(config: config)])

    clientMiddlewareGroup.get("hello") { _ in
      var json = JSON()
      try json.set("hello", "world")
      return json
    }

    clientMiddlewareGroup.get("plaintext") { _ in
      return "Hello, world!"
    }

    try resource("heartbeat", HeartbeatController.self)
    try clientMiddlewareGroup.resource("event", EventController.self)
    try clientMiddlewareGroup.resource("event/:id/speech", EventSpeechController.self)
    try userMiddlewareGroup.resource("event/:id/form", RegistrationFormController.self)
    try userMiddlewareGroup.resource("event/register", RegistrationController.self)

    let userAuthorizationController = UserAuthorizationController(drop: self)
    clientMiddlewareGroup.resource("user/auth", userAuthorizationController)
  }
}
