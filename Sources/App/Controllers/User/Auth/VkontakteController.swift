import HTTP
import Vapor
import Fluent
import Crypto

final class VkontakteController {

  private let drop: Droplet
  private let config: Config
  private let photoController: PhotoController
  private let vk = Social.VK.self

  init(drop: Droplet) {
    self.drop = drop
    self.config = drop.config
    self.photoController = PhotoController(drop: self.drop)
  }

  func createOrUpdateUserProfile(use token: String, secret: String) throws -> User {

    let (profile, socialUserId) = try getUserProfile(with: token, secret: secret)

    if let user = try SocialAccount.find(by: socialUserId) {
      user.name = profile.name
      user.lastname = profile.lastname
      user.photo = try photoController.downloadAndSavePhoto(for: user, with: profile.photo)
      try user.save()
      return user
    }

    try profile.save()

    if let url = profile.photo, !url.isEmpty {
      profile.photo = try photoController.downloadAndSavePhoto(for: profile, with: profile.photo)
      try profile.save()
    }
    
    try SocialHelper.storeSocialProfile(for: profile, socialUserId: socialUserId, social: Social.Nets.vk)

    return profile
  }

  fileprivate func getUserProfile(with token: String, secret: String) throws -> (user: User, socialUserId: String) {
    let apiURL = config[vk.name, vk.apiURL]?.string ?? ""
    let fields = config[vk.name, vk.fields]?.string ?? ""
    let method = config[vk.name, vk.method]?.string ?? ""

    let urlForSignature =  "\(method)?\(vk.fields)=\(fields)&\(vk.accessToken)=\(token + secret)"

    let signature = try CryptoHasher.makeMD5(from: urlForSignature)
    let userInfoUrl = apiURL + method
    let userInfo = try drop.client.get(userInfoUrl, query: [
      vk.fields: fields,
      vk.accessToken: token,
      vk.sig: signature
    ])

    let profile = vk.Profile.self
    guard
      let response = userInfo.json?[profile.response]?.array?.first,
      let socialUserId = response[profile.socialUserId]?.string,
      let name = response[profile.name]?.string,
      let lastname = response[profile.lastname]?.string,
      let photo = response[profile.photo]?.string
    else {
        throw Abort(.badRequest, reason: "Can't get user profile from Vkontakte")
    }

    let user = User(
      name: name,
      lastname: lastname,
      photo: photo)

    return (user, socialUserId)
  }

}
