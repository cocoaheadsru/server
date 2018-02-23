import Vapor

struct GithubConfig {
  private let github = Social.Github.self
  let tokenRequestURL: String
  let clientId: String
  let clientSecret: String
  let userInfoURL: String
  var code: String?
  var state: String?
  var accessToken: String?
  var testUserInfoURL: String?

  init(_ config: Config) {
    guard
      let tokenRequestURL = config[github.name, github.tokenRequestURL]?.string,
      let clientId = config[github.name, github.clientId]?.string,
      let clientSecret = config[github.name, github.clientSecret]?.string,
      let userInfoURL = config[github.name, github.userInfoURL]?.string
    else {
        fatalError("Can't read config from github.json")
    }

    self.tokenRequestURL = tokenRequestURL
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.userInfoURL = userInfoURL

    if config.environment == .test {
      code = config[github.name, github.code]?.string ?? ""
      accessToken = config[github.name, github.accessToken]?.string ?? ""
      state = config[github.name, github.state]?.string ?? ""
      guard (code != nil  || accessToken != nil) && state != nil else {
        fatalError("Can't read token or code from test facebook.json")
      }
      testUserInfoURL = config[github.name, github.testUserInfoURL]?.string ?? ""
    }
  }

}
