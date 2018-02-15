import HTTP
import Vapor
import Fluent

final class FacebookController {

  private let drop: Droplet
  private let config: Config
  private let photoController: PhotoConroller
  private let fb = Social.FB.self

  init(drop: Droplet) {
    self.drop = drop
    self.config = drop.config
    self.photoController = PhotoConroller(drop: self.drop)
  }

  func createOrUpdateUserProfile(use authorizateCode: String) throws -> User {

    let accessToken = try authorizate(by: authorizateCode)
    let (profile, socialUserId)  = try getUserProfile(use: accessToken)

    if let user = try SocialAccount.find(by: socialUserId) {
      user.name = profile.name
      user.lastname = profile.lastname
      user.email = profile.email
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

  fileprivate func authorizate(by authorizateCode: String) throws -> String {

    if
      config.environment == .test,
      authorizateCode.isEmpty,
      let accessTokenFromConfig = config[fb.name, fb.accessToken]?.string,
      !accessTokenFromConfig.isEmpty {
      print("\n\nUSING TOKEN FROM CONGIG FILE\n\n")
      return accessTokenFromConfig
    }

    let authURL = config[fb.name, fb.tokenRequestURL]?.string ?? ""
    let clientId = config[fb.name, fb.clientId]?.string ?? ""
    let redirectURI = config[fb.name, fb.redirectURI]?.string ?? ""
    let scope = config[fb.name, fb.scope]?.string ?? ""
    let clientSecret = config[fb.name, fb.clientSecret]?.string ?? ""
    let code = authorizateCode + "#_=_"
    
    let authRequest = try drop.client.get(authURL, query: [
      fb.clientId: clientId,
      fb.redirectURI: redirectURI,
      fb.scope: scope,
      fb.clientSecret: clientSecret,
      fb.code: code
    ])

    guard  let accessToken = authRequest.json?[fb.accessToken]?.string else {
      throw Abort(.badRequest, reason: "Can't get 'access_token' from Facebook")
    }
    
    return accessToken
  }

  fileprivate func getUserProfile(use token: String) throws -> (user: User, socialUserId: String) {

    let userInfoUrl =  config[fb.name, fb.userInfoURL]?.string ?? ""
    let fields  =  config[fb.name, fb.fields]?.string ?? ""
    let scope = config[fb.name, fb.scope]?.string ?? ""

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
