import Vapor

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
extension Samples {

  func createSpeakerSample() throws {

    let users: [User] = try! User.all()
    let events: [Event] =  try! Event.all()

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
        let range = 0...Int.random(min: 1, max: usersShuffled.count - 1 < 2 ? usersShuffled.count - 1 : 2)
        for i in range {

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
