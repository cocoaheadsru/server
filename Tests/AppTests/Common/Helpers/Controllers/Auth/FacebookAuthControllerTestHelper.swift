import Vapor
import Foundation
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class FacebookAuthControllerTestHelper {

  static func getTestRequest(config: Config) throws -> JSON? {
    guard let token = config[Social.Nets.fb, "code"]?.string else {
      return nil
    }
    let result = try! JSON(
      node: [
        "token": token,
        "social": Social.Nets.fb
    ])
    return result
  }

  static func getUserInfoFromSocial(drop: Droplet) throws -> JSON? {
    let config = drop.config
    let userInfoUrl = config[Social.Nets.fb, "user_info_url"]?.string ?? ""
    let fields = config[Social.Nets.fb, "fields"]?.string ?? ""
    let scope = config[Social.Nets.fb, "scope"]?.string ?? ""
    let token = config[Social.Nets.fb, "access_token"]?.string ?? ""
    
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

    let Keys = User.Keys.self
    var json = JSON()
    try json.set(Keys.name, name)
    try json.set(Keys.lastname, lastname)
    try json.set(Keys.company, "")
    try json.set(Keys.position, "")
    try json.set(Keys.photo, photo)
    try json.set(Keys.email, email)
    try json.set(Keys.phone, "")
    return json
  }

}
