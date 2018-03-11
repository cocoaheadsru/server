import HTTP
import Vapor
import Fluent

final class UserAuthorizationController {

  private let fb: FacebookController
  private let vk: VkontakteController
  private let git: GithubController
  
  init(drop: Droplet) {
    fb = FacebookController(drop: drop)
    vk = VkontakteController(drop: drop)
    git = GithubController(drop: drop)
  }

  func store(_ request: Request) throws -> ResponseRepresentable {

    guard let token = request.json?[RequestKeys.token]?.string else {
      throw Abort(.badRequest, reason: "Can't get 'token' from request")
    }

    guard let social = request.json?[RequestKeys.social]?.string else {
      throw Abort(.badRequest, reason: "Can't get 'social' from request")
    }

    var user: User

    switch social {
    case Social.Nets.fb:
      user = try fb.createOrUpdateUserProfile(with: token)
    case Social.Nets.vk:
      guard let secret = request.json?[RequestKeys.secret]?.string else {
        throw Abort(.badRequest, reason: "Can't get 'secret' from request")
      }
      user = try vk.createOrUpdateUserProfile(use: token, secret: secret)
    case Social.Nets.github:
      guard let secret = request.json?[RequestKeys.secret]?.string else {
        throw Abort(.badRequest, reason: "Can't get 'secret' from request")
      }
      user = try git.createOrUpdateUserProfile(with: token, secret: secret)
    default:
      throw Abort(.badRequest, reason: "Wrong social id: \(social)")
    }

    if user.token == nil {
      user.createSession()
    } else {
      try user.updateSessionToken()
    }

    return user
  }

}

extension UserAuthorizationController: ResourceRepresentable {

  func makeResource() -> Resource<User> {
    return Resource(
      store: store
    )
  }
}

extension UserAuthorizationController {

  struct RequestKeys {
    static let token = "token"
    static let social = "social"
    static let secret = "secret"
  }

}
