import Vapor
import Foundation
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class GithubAuthControllerTestHelper {

  static func getTestRequest(config: Config) throws -> JSON? {
    guard
      let token = config[Social.Nets.github, "code"]?.string,
      let secret = config[Social.Nets.github, "state"]?.string
      else {
        return nil
    }
    let result = try! JSON(
      node: [
        "token": token,
        "social": Social.Nets.github,
        "secret": secret
      ])
    return result
  }

  static func getUserInfoFromSocial(drop: Droplet) throws -> JSON? {

    let config = drop.config
    let apiURL = config[Social.Nets.github, "user_info_url"]?.string ?? ""
    let token = config[Social.Nets.github, "access_token"]?.string ?? ""

    let userInfo = try! drop.client.get(apiURL, query: [
      "access_token": token
    ])

    guard
      let response = userInfo.json,
      let login = response["login"]?.string,
      let photo = response["avatar_url"]?.string
      else {
        throw Abort(.badRequest, reason: "Can't get user profile from Github")
    }

    let fullName = response["name"]?.string ?? login
    let nameComponents = fullName.components(separatedBy: " ")
    let name = nameComponents[0]
    let lastname = nameComponents[safe: 1]

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
