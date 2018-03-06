import HTTP
import Vapor
import Fluent
import Crypto

final class VkontakteController {

  private let drop: Droplet
  private let photoController: PhotoController
  private let vk = Social.VK.self
  private let config: VkontakteConfig

  init(drop: Droplet) {
    self.drop = drop
    self.photoController = PhotoController(drop: self.drop)
    self.config = VkontakteConfig(drop.config)
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

    if let url = profile.photo, url.isNotEmpty {
      profile.photo = try photoController.downloadAndSavePhoto(for: profile, with: profile.photo)
      try profile.save()
    }
    
    try SocialHelper.storeSocialProfile(for: profile, socialUserId: socialUserId, social: Social.Nets.vk)

    return profile
  }

  fileprivate func getUserProfile(with token: String, secret: String) throws -> (user: User, socialUserId: String) {

    let signature = try config.getSignatureBased(on: token, and: secret)
    let userInfo = try drop.client.get(config.userInfoURL, query: [
      vk.fields: config.fields,
      vk.accessToken: token,
      vk.sig: signature,
      vk.version: vk.versionValue
    ])

    let profile = vk.Profile.self
    guard
      let json =  userInfo.json,
      let response = json[profile.response]?.array?.first,
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
