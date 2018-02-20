import HTTP
import Vapor
import Fluent

final class GithubController {

  private let drop: Droplet
  private let config: Config
  private let photoController: PhotoController
  private let git = Social.GIT.self

  init(drop: Droplet) {
    self.drop = drop
    self.config = drop.config
    self.photoController = PhotoController(drop: self.drop)
  }

  func createOrUpdateUserProfile(use authorizateCode: String, secret: String) throws -> User {

    let accessToken = try authorizate(by: authorizateCode, secret: secret)
    let (profile, socialUserId) = try getUserProfile(use: accessToken)

    if let user = try SocialAccount.find(by: socialUserId) {
      user.name = profile.name
      user.lastname = profile.lastname
      user.photo = try photoController.downloadAndSavePhoto(for: user, by: profile.photo)
      try user.save()
      return user
    }

    try profile.save()

    if let url = profile.photo, !url.isEmpty {
      profile.photo = try photoController.downloadAndSavePhoto(for: profile, by: profile.photo)
      try profile.save()
    }

    try SocialHelper.storeSocialProfile(for: profile, socialUserId: socialUserId, social: Social.Nets.fb)

    return profile
  }

  fileprivate func authorizate(by authorizateCode: String, secret: String) throws -> String {

    if
      config.environment == .test,
      authorizateCode.isEmpty,
      let accessTokenFromConfig = config[git.name, git.accessToken]?.string,
      !accessTokenFromConfig.isEmpty {
      print("\n\nUSING TOKEN FROM CONGIG FILE\n\n")
      return accessTokenFromConfig
    }

    let authURL = config[git.name, git.tokenRequestURL]?.string ?? ""
    let clientId = config[git.name, git.clientId]?.string ?? ""
    let clientSecret = config[git.name, git.clientSecret]?.string ?? ""
    let code = authorizateCode
    let state = secret

    let authRequest = try drop.client.get(authURL, query: [
      git.clientId: clientId,
      git.state: state,
      git.clientSecret: clientSecret,
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

  fileprivate func getUserProfile(use token: String) throws -> (user: User, socialUserId: String) {

    let userInfoUrl = config[git.name, git.userInfoURL]?.string ?? ""
    let userInfo = try drop.client.get(userInfoUrl, query: [
      git.accessToken: token
    ])

    let profile = git.Profile.self
    guard
      let response = userInfo.json,
      let login = response[profile.login]?.string,
      let photo = response[profile.photo]?.string
    else {
        throw Abort(.badRequest, reason: "Can't get user profile from Github")
    }

    let names = response[profile.name]?.string ?? login
    let fullName = names.components(separatedBy: " ")
    let name: String = fullName[0]
    let lastname: String? = fullName.count > 1 ? fullName[1] : nil

    let user = User(
      name: name,
      lastname: lastname,
      photo: photo)

    let socialUserId = profile.socialUserId + login

    return (user, socialUserId)
  }

}
