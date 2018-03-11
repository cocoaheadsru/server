import HTTP
import Vapor
import Fluent

final class GithubController {

  private let drop: Droplet
  private let photoController: PhotoController
  private let git = Social.Github.self
  private let config: GithubConfig

  init(drop: Droplet) {
    self.drop = drop
    self.config = GithubConfig(drop.config)
    self.photoController = PhotoController(drop: self.drop)
  }

  func createOrUpdateUserProfile(with authorizationCode: String, secret: String) throws -> User {

    let accessToken = try authorize(by: authorizationCode, secret: secret)
    let (profile, socialUserId) = try getUserProfile(with: accessToken)

    if let user = try SocialAccount.find(by: socialUserId) {
      user.name = profile.name
      user.lastname = profile.lastname
      user.photo = try photoController.downloadAndSavePhoto(for: user, with: profile.photo)
      try user.save()
      return user
    }

    try profile.save()

    if let url = profile.photo, url.isNotEmpty {
      profile.photo = try photoController.downloadAndSavePhoto(for: profile, with: profile.photo)
      try profile.save()
    }

    try SocialHelper.storeSocialProfile(for: profile, socialUserId: socialUserId, social: Social.Nets.fb)

    return profile
  }

  fileprivate func authorize(by authorizationCode: String, secret: String) throws -> String {

    if
      drop.config.environment == .test,
      authorizationCode.isEmpty,
      let accessTokenFromConfig = config.accessToken,
      accessTokenFromConfig.isNotEmpty {
      print("\n\nUSING TOKEN FROM CONFIG FILE\n\n")
      return accessTokenFromConfig
    }

    let code = authorizationCode
    let state = secret

    let authRequest = try drop.client.get(config.tokenRequestURL, query: [
      git.clientId: config.clientId,
      git.state: state,
      git.clientSecret: config.clientSecret,
      git.code: code
    ])

    guard let node = authRequest.formURLEncoded else {
      throw Abort(.badRequest, reason: "Can't encode formURL from Github")
    }

    let response = JSON(node: node)

    guard let accessToken = response[git.accessToken]?.string else {
      throw Abort(.badRequest, reason: "Can't get 'access_token' from Github")
    }

    return accessToken
  }

  fileprivate func getUserProfile(with token: String) throws -> (user: User, socialUserId: String) {

    let userInfo = try drop.client.get( config.userInfoURL, query: [
      git.accessToken: token
    ])

    let profile = git.Profile.self
    guard let response = userInfo.json else {
       throw Abort(.internalServerError, reason: "Can't get json from github answer")
    }

    guard
      let login = response[profile.login]?.string,
      let photo = response[profile.photo]?.string
    else {
        throw Abort(.badRequest, reason: "Can't get user profile from Github \n \(try response.serialize(prettyPrint: true).makeString())")
    }

    let fullName = response[profile.name]?.string ?? login
    let nameComponents = fullName.components(separatedBy: " ")
    let name = nameComponents[0]
    let lastname = nameComponents[safe: 1]

    let user = User(
      name: name,
      lastname: lastname,
      photo: photo)

    let socialUserId = profile.socialUserId + login

    return (user, socialUserId)
  }

}
