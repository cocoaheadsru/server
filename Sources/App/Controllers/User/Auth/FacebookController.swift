import HTTP
import Vapor
import Fluent

final class FacebookController {

  private let drop: Droplet
  private let photoController: PhotoController
  private let fb = Social.FB.self
  private let config: FacebookConfig

  init(drop: Droplet) {
    self.drop = drop
    self.config = FacebookConfig(drop.config)
    self.photoController = PhotoController(drop: self.drop)
  }

  func createOrUpdateUserProfile(with authorizationCode: String) throws -> User {

    let accessToken = try authorize(by: authorizationCode)
    let (profile, socialUserId) = try getUserProfile(with: accessToken)

    if let user = try SocialAccount.find(by: socialUserId) {
      user.name = profile.name
      user.lastname = profile.lastname
      user.email = profile.email
      user.photo = try photoController.downloadAndSavePhoto(for: user, with: profile.photo)
      try user.save()
      return user
    }

    try profile.save()

    if let url = profile.photo, !url.isEmpty {
      profile.photo = try photoController.downloadAndSavePhoto(for: profile, with: profile.photo)
      try profile.save()
    }

    try SocialHelper.storeSocialProfile(for: profile, socialUserId: socialUserId, social: Social.Nets.fb)

    return profile
  }

  fileprivate func authorize(by authorizationCode: String) throws -> String {

    if
      drop.config.environment == .test,
      authorizationCode.isEmpty,
      let accessTokenFromConfig = config.accessToken,
      accessTokenFromConfig.isNotEmpty {
      print("\n\nUSING TOKEN FROM CONFIG FILE\n\n")
      return accessTokenFromConfig
    }

    let code = authorizationCode + "#_=_"
    
    let authRequest = try drop.client.get(config.tokenRequestURL, query: [
      fb.clientId: config.clientId,
      fb.redirectURI: config.redirectURI,
      fb.scope: config.scope,
      fb.clientSecret: config.clientSecret,
      fb.code: code
    ])

    guard  let accessToken = authRequest.json?[fb.accessToken]?.string else {
      throw Abort(.badRequest, reason: "Can't get 'access_token' from Facebook")
    }
    
    return accessToken
  }

  fileprivate func getUserProfile(with token: String) throws -> (user: User, socialUserId: String) {

    let userInfoUrl =  config.userInfoURL
    let fields  =  config.fields
    let scope = config.scope

    let userInfo = try drop.client.get(userInfoUrl, query: [
      fb.fields: fields,
      fb.scope: scope,
      fb.accessToken: token
    ])

    let profile = fb.Profile.self
    guard
      let socialUserId = userInfo.json?[profile.socialUserId]?.string,
      let name = userInfo.json?[profile.name]?.string,
      let lastname = userInfo.json?[profile.lastname]?.string,
      let email = userInfo.json?[profile.email]?.string,
      let photo = userInfo.json?[profile.photo]?.string
    else {
        throw Abort(.badRequest, reason: "Can't get user profile from Facebook")
    }

    let user = User(
      name: name,
      lastname: lastname,
      photo: photo,
      email: email)

    return (user, socialUserId)
  }

}
