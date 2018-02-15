import Vapor
import Foundation
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class VkontakteAuthControllerTestHelper {

  static func getTestRequest(config: Config) throws -> JSON? {
    guard
      let token = config[Social.Nets.vk, "access_token"]?.string,
      let secret = config[Social.Nets.vk, "secret"]?.string
    else {
      return nil
    }
    let result = try! JSON(
      node: [
        "token": token,
        "social": Social.Nets.vk,
        "secret": secret
      ])
    return result
  }

  static func getUserInfoFromSocial(drop: Droplet) throws -> JSON? {

    func makeMD5(string: String) throws -> String {
      let md5 =  CryptoHasher(hash: .md5, encoding: .hex)
      let signature = try md5.make(string.makeBytes())
      return signature.makeString()
    }

    let config = drop.config
    let apiURL = config[Social.Nets.vk, "api_url"]?.string ?? ""
    let fields = config[Social.Nets.vk, "fields"]?.string ?? ""
    let method = config[Social.Nets.vk, "method"]?.string ?? ""
    let token = config[Social.Nets.vk, "access_token"]?.string ?? ""
    let secret = config[Social.Nets.vk, "secret"]?.string ?? ""

    let urlForSignature =  "\(method)?fields=\(fields)&access_token=\(token + secret)"

    let signature = try! makeMD5(string: urlForSignature)
    let userInfoUrl = apiURL + method
    let userInfo = try! drop.client.get(userInfoUrl, query: [
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

    let Keys = User.Keys.self
    var json = JSON()
    try json.set(Keys.name, name)
    try json.set(Keys.lastname, lastname)
    try json.set(Keys.company, JSON.null)
    try json.set(Keys.position, JSON.null)
    if
      let url = URL(string: photo),
      let domen = drop.config["app", "domain"]?.string {
      try json.set(Keys.photo, "\(domen)/user_photos/1/\(url.lastPathComponent)")
    } else {
      try json.set(Keys.photo, photo)
    }
    try json.set(Keys.email, JSON.null)
    try json.set(Keys.phone, JSON.null)
    return json
  }

}
