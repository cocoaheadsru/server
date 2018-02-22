import Vapor
import Crypto

struct VkontakteConfig {
  private let vk = Social.VK.self
  let apiURL: String
  let fields: String
  let method: String
  var secret: String = ""
  var accessToken: String = ""
  var userInfoURL: String {
    return apiURL + method
  }

  init(_ config: Config) {
    guard
      let apiURL = config[vk.name, vk.apiURL]?.string,
      let fields = config[vk.name, vk.fields]?.string,
      let method = config[vk.name, vk.method]?.string
    else {
      fatalError("Can't read config from vkontakte.json")
    }

    self.apiURL = apiURL
    self.fields = fields
    self.method = method

    if config.environment == .test {
      guard
        let secret = config[vk.name, vk.secret]?.string,
        let accessToken = config[vk.name, vk.accessToken]?.string
      else {
        fatalError("Can't read token & secret from test vkontakte.json")
      }
      self.secret = secret
      self.accessToken = accessToken
    }

  }

  func getSignatureBased(on token: String, and secret: String)throws -> String {
    let urlForSignature = "\(method)?\(vk.fields)=\(fields)&\(vk.accessToken)=\(token + secret)"
    return try CryptoHasher.makeMD5(from: urlForSignature)
  }

}
