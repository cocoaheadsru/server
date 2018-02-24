import Vapor

struct FacebookConfig {
  private let fb = Social.FB.self
  let tokenRequestURL: String
  let clientId: String
  let redirectURI: String
  let scope: String
  let clientSecret: String
  let userInfoURL: String
  let fields: String
  var code: String?
  var accessToken: String?

  init(_ config: Config) {
    guard
      let tokenRequestURL = config[fb.name, fb.tokenRequestURL]?.string,
      let clientId = config[fb.name, fb.clientId]?.string,
      let redirectURI = config[fb.name, fb.redirectURI]?.string,
      let scope = config[fb.name, fb.scope]?.string,
      let clientSecret = config[fb.name, fb.clientSecret]?.string,
      let userInfoURL = config[fb.name, fb.userInfoURL]?.string,
      let fields = config[fb.name, fb.fields]?.string
      else {
        fatalError("Can't read config from facebook.json")
    }

    self.tokenRequestURL = tokenRequestURL
    self.clientId = clientId
    self.redirectURI = redirectURI
    self.scope = scope
    self.clientSecret = clientSecret
    self.userInfoURL = userInfoURL
    self.fields = fields

    if config.environment == .test {
      code = config[fb.name, fb.code]?.string ?? ""
      accessToken = config[fb.name, fb.accessToken]?.string ?? ""

      guard code != nil  || accessToken != nil else {
        fatalError("Can't read token or code from test facebook.json")
      }
    }
  }

}
