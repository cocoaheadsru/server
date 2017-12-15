import Vapor
@testable import App

class EventSpeechHelper {
  
  static func cleanSpeechTable() throws {
    try App.Content.makeQuery().delete()
    try Speaker.makeQuery().delete()
    try User.makeQuery().delete()
    try Speech.makeQuery().delete()
  }
  
  static func storeSpeech(forEventId eventId: Identifier) throws {
    let speech = Speech(eventId: eventId,
                        title: String.randomValue,
                        description: String.randomValue,
                        photoUrl: String.randomValue)
    try speech.save()
    
    let user1 = User.init(name: String.randomValue,
                          lastname: String.randomValue,
                          company: String.randomValue,
                          position: String.randomValue,
                          photo: String.randomValue,
                          email: String.randomValue,
                          phone: String.randomValue)
    let user2 = User.init(name: String.randomValue,
                          lastname: String.randomValue,
                          company: String.randomValue,
                          position: String.randomValue,
                          photo: String.randomValue,
                          email: String.randomValue,
                          phone: String.randomValue)
    try user1.save()
    try user2.save()
    
    let speaker1 = Speaker(userId: user1.id!, speechId: speech.id!)
    let speaker2 = Speaker(userId: user2.id!, speechId: speech.id!)
    try speaker1.save()
    try speaker2.save()
    
    let content1 = Content(speechId: speech.id!,
                           title: String.randomValue,
                           description: String.randomValue,
                           link: String.randomValue,
                           type: .video)
    let content2 = Content(speechId: speech.id!,
                           title: String.randomValue,
                           description: String.randomValue,
                           link: String.randomValue,
                           type: .slide)
    try content1.save()
    try content2.save()
  }
}
