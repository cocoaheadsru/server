import Vapor
import AuthProvider

extension Droplet {
  func setupRoutes() throws {
    let clientMiddlewareGroup = grouped(try ClientMiddleware(config: config))
    let userMiddlewareGroup = grouped([
      try ClientMiddleware(config: config),
      TokenAuthenticationMiddleware(User.self)
    ])

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

    let userController = UserController(drop: self)
    userMiddlewareGroup.resource("user", userController)

    try userMiddlewareGroup.resource("user/notification", PushNotificationController.self)
    try userMiddlewareGroup.resource("user/give-speech", GiveSpeechController.self)

    try clientMiddlewareGroup.resource("user/creators", CreatorsController.self)

  }
}
