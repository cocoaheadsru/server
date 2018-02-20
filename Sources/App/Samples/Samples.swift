import Vapor
import AuthProvider

extension Droplet {

  func setupSamples() throws {

    guard  self.config.environment == .development else {
      return
    }

    try truncateTables()
    let userSample = UserSample(drop: self)
    try userSample.createSample()

  }

}
