import Vapor
@testable import App

class EventSpeechHelper {
  
  static func cleanSpeechTable() throws {
    try App.Content.makeQuery().delete()
    try Speaker.makeQuery().delete()
    try User.makeQuery().delete()
    try Speech.makeQuery().delete()
  }
  
  static func storeSpeech(forEventId eventId: Identifier, speakersCount: Int = 2, contentCount: Int = 2) throws {
    let speech = Speech(eventId: eventId,
                        title: String.randomValue,
                        description: String.randomValue,
                        photoUrl: String.randomValue)
    try speech.save()
    
    for _ in 0..<speakersCount {
      let user = User.init(name: String.randomValue,
                            lastname: String.randomValue,
                            company: String.randomValue,
                            position: String.randomValue,
                            photo: String.randomValue,
                            email: String.randomValue,
                            phone: String.randomValue)
      try user.save()
      
      let speaker = Speaker(userId: user.id!, speechId: speech.id!)
      try speaker.save()
    }
    
    for _ in 0..<contentCount {
      let content = Content(speechId: speech.id!,
                             title: String.randomValue,
                             description: String.randomValue,
                             link: String.randomValue,
                             type: Bool.randomValue ? .video : .slide)
      try content.save()
    }
  }
}
