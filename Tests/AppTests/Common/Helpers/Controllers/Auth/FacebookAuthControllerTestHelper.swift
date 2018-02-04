import Vapor
import Foundation
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class FacebookAuthControllerTestHelper {

  static func getTestRequest(config: Config) throws -> JSON? {
    guard let token = config["facebook", "code"]?.string else {
      return nil
    }
    let result = try JSON(node: ["token": token])
    return result
  }

  static func getUserSessionToken(by response: JSON) throws -> String? {
    guard
      let userId = response[User.Keys.id]?.int,
      let user = try! User.find(userId),
      let session = try! user.session()
    else {
      return nil
    }

    return session.token
  }

  static func getUserInfoFromSocial(drop: Droplet) throws -> JSON? {
    let config = drop.config
    let userInfoUrl = config["facebook", "user_info_url"]?.string ?? ""
    let fields = config["facebook", "fields"]?.string ?? ""
    let scope = config["facebook", "scope"]?.string ?? ""
    let token = config["facebook", "access_token"]?.string ?? ""
    
    let userInfo = try drop.client.get(userInfoUrl, query: [
      "fields": fields,
      "scope": scope,
      "access_token": token
    ])

    guard
      let socialUserId = userInfo.json?["id"]?.string,
      let name = userInfo.json?["first_name"]?.string,
      let lastname = userInfo.json?["first_name"]?.string,
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
