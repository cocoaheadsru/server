import Vapor
import Foundation
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class VkontakteAuthControllerTestHelper {

  static func getTestRequest() throws -> JSON? {
    let configFile = try! Config(arguments: ["vapor", "--env=test"])
    let config = VkontakteConfig(configFile)
    let token = config.accessToken
    let secret = config.secret

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
    let configFile = try! Config(arguments: ["vapor", "--env=test"])
    let config = VkontakteConfig(configFile)

    let apiURL = config.apiURL
    let fields = config.fields
    let method = config.method
    let token = config.accessToken
    let secret = config.secret

    let signature = try! config.getSignatureBased(on: token, and: secret)
    let userInfoUrl = apiURL + method
    let userInfo = try! drop.client.get(userInfoUrl, query: [
      "fields": fields,
      "access_token": token,
      "sig": signature
    ])

    guard
      let response = userInfo.json?["response"]?.array?.first,
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
