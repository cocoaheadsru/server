import Foundation

extension Social {

  struct Nets {
    static let fb = "facebook"
    static let vk = "vkontakte"
    static let github = "github"
  }

  // swiftlint:disable type_name
  struct FB {
    static let name = Nets.fb
    static let tokenRequestURL = "token_request_url"
    static let clientId = "client_id"
    static let redirectURI = "redirect_uri"
    static let scope = "scope"
    static let clientSecret = "client_secret"
    static let userInfoURL = "user_info_url"
    static let fields = "fields"
    static let accessToken = "access_token"
    static let code = "code"

    struct Profile {
      static let socialUserId = "id"
      static let name = "first_name"
      static let lastname = "last_name"
      static let email = "email"
      static let photo = ["picture", "data", "url"]
    }

  }
  
  // swiftlint:disable type_name
  struct VK {
    static let name = Nets.vk
    static let apiURL = "api_url"
    static let method = "method"
    static let fields = "fields"
    static let accessToken = "access_token"
    static let sig = "sig"
    static let secret = "secret"
    struct Profile {
      static let response = "response"
      static let socialUserId = "uid"
      static let name = "first_name"
      static let lastname = "last_name"
      static let photo = "photo_max"
    }
  }

  struct Github {
    static let name = Nets.github
    static let tokenRequestURL = "token_request_url"
    static let clientId = "client_id"
    static let clientSecret = "client_secret"
    static let userInfoURL = "user_info_url"
    static let accessToken = "access_token"
    static let state = "state"
    static let code = "code"
    struct Profile {
      static let socialUserId = "github.com/"
      static let login = "login"
      static let photo = "avatar_url"
      static let name = "name"
    }
  }

}
