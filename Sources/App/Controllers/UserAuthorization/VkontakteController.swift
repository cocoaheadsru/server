import HTTP
import Vapor
import Fluent
import Crypto

final class VkontakteController {

  private let drop: Droplet
  private let config: Config

  init(drop: Droplet) {
    self.drop = drop
    self.config = drop.config
  }

  func createOrUpdateUserProfileFromVkontake(use token: String, secret: String) throws -> User {

    let (profile, socialUserId)  = try getUserProfileFomrFacebook(use: token, secret: secret)

    if let user = try SocialAccount.find(by: socialUserId) {
      // TODO: Change it to call user/id:/update endpoint
      user.name = profile.name
      user.lastname = profile.lastname
      user.photo = profile.photo
      try user.save()
      return user
    }

    try profile.save()
    try SocialHelper.storeSocialProfile(for: profile, socialUserId: socialUserId, social: Social.Nets.vk)

    return profile
  }

  fileprivate func getUserProfileFomrFacebook(use token: String, secret: String) throws -> (user: User, socialUserId: String) {
    let apiURL = config[Social.Nets.vk, "api_url"]?.string ?? ""
    let fields = config[Social.Nets.vk, "fields"]?.string ?? ""
    let method = config[Social.Nets.vk, "method"]?.string ?? ""

    let urlForSignature =  "\(method)?fields=\(fields)&access_token=\(token + secret)"

    let signature = try CryptoHasher.makeMD5(from: urlForSignature)
    let userInfoUrl = apiURL + method
    let userInfo = try drop.client.get(userInfoUrl, query: [
      "fields": fields,
      "access_token": token,
      "sig": signature
    ])

    guard
      let response = userInfo.json?["response"]?.array?.first,
      let socialUserId = response["uid"]?.string,
      let name = response["first_name"]?.string,
      let lastname = response["last_name"]?.string,
      let photo = response["photo_max"]?.string
      else {
        throw Abort(.badRequest, reason: "Can't get user profile from Vkontakte")
    }

    let user = User(
      name: name,
      lastname: lastname,
      company: "",
      position: "",
      photo: photo,
      email: "",
      phone: "")

    return (user, socialUserId)
  }

}
