import Vapor
import HTTP
import Routing
import AuthProvider

final class FrontendAPICollection: RouteCollection {

  let drop: Droplet
  let config: Config

  init(drop: Droplet) {
    self.drop = drop
    self.config = drop.config
  }

  func build(_ builder: RouteBuilder) throws {

    let frontendAPI = builder.grouped("api")

    let clientMiddlewareGroup = frontendAPI.grouped([
      try ClientMiddleware(config: config),
      try PhotoURLMiddleware(config: config)
    ])

    let userMiddlewareGroup = frontendAPI.grouped([
      try ClientMiddleware(config: config),
      TokenAuthenticationMiddleware(User.self),
      try PhotoURLMiddleware(config: config)
    ])

    // MARK: Event
    try clientMiddlewareGroup.resource("event", EventController.self)
    try clientMiddlewareGroup.resource("event/:id/speech", EventSpeechController.self)

    try userMiddlewareGroup.resource("event/:id/form", RegistrationFormController.self)
    try userMiddlewareGroup.resource("event/register", RegistrationController.self)

    // MARK: User
    let userAuthorizationController = UserAuthorizationController(drop: drop)
    clientMiddlewareGroup.resource("user/auth", userAuthorizationController)

    let userController = UserController(drop: drop)
    userMiddlewareGroup.resource("user", userController)

    try userMiddlewareGroup.resource("user/notification", PushNotificationController.self)
    try userMiddlewareGroup.resource("user/give-speech", GiveSpeechController.self)

    // MARK: Creators
    try clientMiddlewareGroup.resource("user/creators", CreatorsController.self)

  }
  
}
