import Vapor

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class SpeakerSample {

  private let users: [User]
  private let events: [Event]

  init() {
    self.users = try! User.all()
    self.events = try! Event.all()
  }
  
  @discardableResult
  func createSample() throws -> [Speaker] {

    var speakers: [Speaker] = []
    events.forEach { (event)  in
      let usersShuffled = users.shuffled()
      for i in  1...Int.random(min: 1, max: usersShuffled.count < 3 ? usersShuffled.count - 1 : 3) {
        let speech = Speech(
          eventId: event.id!,
          title: String.randomValue,
          description: String.randomValue)
        try! speech.save()

        let speaker = Speaker(
          userId: usersShuffled[i].id!,
          speechId: speech.id!)
        try! speaker.save()
        speakers.append(speaker)
      }
    }
    return speakers
  }

}
