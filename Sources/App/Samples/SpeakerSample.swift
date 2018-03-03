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
  
  func createSample() throws {

    events.forEach { (event)  in
      
      for _ in  1...Int.random(min: 2, max:5) {
        //speech
        let speech = Speech(
          eventId: event.id!,
          title: String.randomValue,
          description: String.randomValue)
        try! speech.save()

        //content
        let content = Content(
          speechId: speech.id!,
          title: String.randomValue,
          description: String.randomValue,
          link: String.randomURL,
          type: Content.ContentType.video)
        try! content.save()

        if Bool.randomValue {
          let content = Content(
            speechId: speech.id!,
            title: String.randomValue,
            description: String.randomValue,
            link: String.randomURL,
            type: Content.ContentType.slide)
          try! content.save()
        }

        // speaker(s)
        let usersShuffled = users.shuffled()
        for i in  0...Int.random(min: 1, max: usersShuffled.count - 1 < 2 ? usersShuffled.count - 1 : 2) {

          let speaker = Speaker(
            userId: usersShuffled[i].id!,
            speechId: speech.id!)
          try! speaker.save()

          if Bool.randomValue && Bool.randomValue { // second speaker
            let speaker = Speaker(
              userId: usersShuffled[usersShuffled.count - 1 - i].id!,
              speechId: speech.id!)
            try! speaker.save()
          }

        }

      } // for

    } // events.forEach
  }  // func createSample()

}
