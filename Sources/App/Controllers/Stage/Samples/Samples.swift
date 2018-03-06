import Vapor
import AuthProvider

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try

final class Samples {
  let drop: Droplet

  init (drop: Droplet) {
    self.drop = drop
  }

}

extension Samples {

  func create() throws {

    guard  drop.config.environment == .development else {
      return
    }

    try truncateTables()
    try createUserSample()
    try createCreatorSample()
    try createEventSample()
    try createSpeakerSample()
    try createRegFormSample()

  }

}
