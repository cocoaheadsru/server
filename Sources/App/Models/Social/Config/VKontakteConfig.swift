import Vapor
import Crypto

struct VkontakteConfig {
  private let vk = Social.VK.self
  private let config: Config
  let apiURL: String
  let fields: String
  let method: String
  var secret: String = ""
  var accessToken: String = ""

  init(_ config: Config) {
    self.config = config
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
      guard let configTest = try? Config(arguments: ["vapor", "--env=test"]) else {
        fatalError("Can't access to test config file")
      }
      secret = configTest[vk.name, vk.secret]?.string ?? ""
      accessToken = configTest[vk.name, vk.accessToken]?.string ?? ""
    }

  }

  func getSignatureBased(on token: String, and secret: String)throws -> String {
    let urlForSignature = "\(method)?\(vk.fields)=\(fields)&\(vk.accessToken)=\(token + secret)"
    return try CryptoHasher.makeMD5(from: urlForSignature)
  }

}


