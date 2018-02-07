import HTTP
import Vapor
import Fluent

final class FacebookController {

  private let drop: Droplet
  private let config: Config

  init(drop: Droplet) {
    self.drop = drop
    self.config = drop.config
  }

  func createOrUpdateUserProfileFromFacebook(use authorizateCode: String) throws -> User {

    let accessToken = try authorizateFacebookUser(by: authorizateCode)
    let (profile, socialUserId)  = try getUserProfileFomrFacebook(use: accessToken)

    if let user = try SocialAccount.find(by: socialUserId) {
      // TODO: Change it to call user/id:/update endpoint
      user.name = profile.name
      user.lastname = profile.lastname
      user.email =  profile.email
      user.photo = profile.photo
      try user.save()
      return user
    }

    try profile.save()
    try SocialHelper.storeSocialProfile(for: profile, socialUserId: socialUserId, social: Social.Nets.fb)
    
    return profile
  }

  fileprivate func authorizateFacebookUser(by authorizateCode: String) throws -> String {
    
    let authURL = config[Social.Nets.fb, "auth_url"]?.string ?? ""
    let clientId = config[Social.Nets.fb, "client_id"]?.string ?? ""
    let redirectURI = config[Social.Nets.fb, "redirect_uri"]?.string ?? ""
    let scope = config[Social.Nets.fb, "scope"]?.string ?? ""
    let clientSecret = config[Social.Nets.fb, "client_secret"]?.string ?? ""
    let code = authorizateCode + "#_=_"
    
    let authRequest = try drop.client.get(authURL, query: [
      "client_id": clientId,
      "redirect_uri": redirectURI,
      "scope": scope,
      "client_secret": clientSecret,
      "code": code
    ])

    if let accessTokenFromConfig = config[Social.Nets.fb, "access_token"]?.string,
      !accessTokenFromConfig.isEmpty {
      print("\n\nUSE TOKEN FROM CONGIG FILE\nREMOVE access_token FOR PRODUCTION MODE\n\n")
      return accessTokenFromConfig
    }
    
    guard  let accessToken = authRequest.json?["access_token"]?.string else {
      throw Abort(.badRequest, reason: "Can't get 'access_token' from Facebook")
    }
    
    return accessToken
  }

  fileprivate func getUserProfileFomrFacebook(use token: String) throws -> (user: User, socialUserId: String) {

    let userInfoUrl =  config[Social.Nets.fb, "user_info_url"]?.string ?? ""
    let fields  =  config[Social.Nets.fb, "fields"]?.string ?? ""
    let scope = config[Social.Nets.fb, "scope"]?.string ?? ""

    let userInfo = try drop.client.get(userInfoUrl, query: [
      "fields": fields,
      "scope": scope,
      "access_token": token
    ])

    guard
      let socialUserId = userInfo.json?["id"]?.string,
      let name = userInfo.json?["first_name"]?.string,
      let lastname = userInfo.json?["last_name"]?.string,
      let email = userInfo.json?["email"]?.string,
      let photo = userInfo.json?["picture", "data", "url"]?.string
    else {
        throw Abort(.badRequest, reason: "Can't get user profile from Facebook")
    }

    let user = User(
      name: name,
      lastname: lastname,
      company: "",
      position: "",
      photo: photo,
      email: email,
      phone: "")

    return (user, socialUserId)
  }

}
