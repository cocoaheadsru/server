import Vapor

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
extension Samples {

  func createSpeakerSample() throws {

    func createSpeech(for eventId: Identifier) -> Speech {
      let speech = Speech(
        eventId: eventId,
        title: String.randomValue,
        description: String.randomValue)
      try! speech.save()
      return speech
    }

    @discardableResult
    func createContent(for speecchId: Identifier, type: Content.ContentType = Content.ContentType.video) -> Content {
      let content = Content(
        speechId: speecchId,
        title: String.randomValue,
        description: String.randomValue,
        link: String.randomURL,
        type: Content.ContentType.video)
      try! content.save()
      return content
    }

    func createSpeeaker(with users: [User], for speechId: Identifier) {

      let usersShuffled = users.shuffled()
      let range = 0...Int.random(min: 1, max: usersShuffled.count - 1 < 2 ? usersShuffled.count - 1 : 2)
      for index in range {

        let speaker = Speaker(
          userId: usersShuffled[index].id!,
          speechId: speechId)
        try! speaker.save()

        if Bool.randomValue && Bool.randomValue { // second speaker
          let speaker = Speaker(
            userId: usersShuffled[usersShuffled.count - 1 - index].id!,
            speechId: speechId)
          try! speaker.save()
        }

      }

    }

    let users: [User] = try! User.all()
    let events: [Event] =  try! Event.all()

    events.forEach { event  in
      
      for _ in  1...Int.random(min: 2, max:5) {
        let speech = createSpeech(for: event.id!)
        createContent(for: speech.id!)
        if Bool.randomValue {
          createContent(for: speech.id!, type: Content.ContentType.slide)
        }
        createSpeeaker(with: users, for: speech.id!)
      }
    }

  }

}
