import HTTP
import Vapor
import Fluent

final class UserAuthorizationController {

  let drop: Droplet
  let config: Config

  init(drop: Droplet) {
    self.drop = drop
    self.config = drop.config
  }

  func store(_ req: Request) throws -> ResponseRepresentable {

    func authorizateFacebookUser(by authorizateCode: String) throws -> String {

      let authURL = config["facebook", "auth_url"]?.string ?? ""
      let clientId = config["facebook", "client_id"]?.string ?? ""
      let redirectURI = config["facebook", "redirect_uri"]?.string ?? ""
      let scope = config["facebook", "scope"]?.string ?? ""
      let clientSecret = config["facebook", "client_secret"]?.string ?? ""
      let code = authorizateCode + "#_=_"

      let authRequest = try drop.client.get(authURL, query: [
        "client_id": clientId,
        "redirect_uri": redirectURI,
        "scope": scope,
        "client_secret": clientSecret,
        "code": code
      ])

      //UNCOMENT THIS AFTER DEBUG
//      guard  let accessToken = authRequest.json?["access_token"]?.string else {
//        throw Abort(.badRequest, reason: "Can't get 'access_token' from Facebook")
//      }

      // DELETE THIS AFTER DEBUG
      let accessToken = config["facebook", "access_token"]?.string ?? ""

      return accessToken

    }

    func createUserByFacebookProfile(use token: String) throws -> User {

      let userInfoUrl =  config["facebook", "user_info_url"]?.string ?? ""
      let fields  =  config["facebook", "fields"]?.string ?? ""
      let scope = config["facebook", "scope"]?.string ?? ""

      let userInfo = try drop.client.get(userInfoUrl, query: [
        "fields": fields,
        "scope": scope,
        "access_token": token
      ])

      //DEBUG
      let jsonUserInfo = userInfo.json!
      print(try jsonUserInfo.serialize(prettyPrint: true).makeString())
      //END DEBUG

      guard
        let socialUserId = userInfo.json?["id"]?.string,
        let name = userInfo.json?["first_name"]?.string,
        let lastname = userInfo.json?["first_name"]?.string,
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

      try user.save()
      return user
    }

    guard let code = req.json?["token"]?.string else {
      throw Abort(.badRequest, reason: "Can't get 'token' from request")
    }

    //FB
    let accessToken = try authorizateFacebookUser(by: code)
    let user = try  createUserByFacebookProfile(use: accessToken)
    //

    return user
  }

}

extension UserAuthorizationController: ResourceRepresentable {

  func makeResource() -> Resource<User> {
    return Resource(
      store: store
    )
  }
}
