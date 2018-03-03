import Vapor
import AuthProvider

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
extension Droplet {

  func setupSamples() throws {

    guard  self.config.environment == .development else {
      return
    }

    try truncateTables()

    let userSample = UserSample(drop: self)
    try! userSample.createSample()

    let creatorSample = CreatorSample(drop: self)
    try! creatorSample.createSample()

    let eventSample = EventSample(drop: self)
    try! eventSample.createSample()

    let speakerSample = SpeakerSample()
    try! speakerSample.createSample()

    let regFormSample = RegFormSample()
    try! regFormSample.createSample()

  }

}
