import Vapor
@testable import App

class EventSpeechHelper {
  
  static var invalidParameterKey: String {
    let parameter = String.randomValue
    if parameter == "id" {
      return self.invalidParameterKey
    }
    return parameter
  }
  
  static var invalidParameterValue: String {
    let parameter = String.randomValue
    if parameter.int != nil {
      return self.invalidParameterValue
    }
    return parameter
  }
  
  static func storeSpeech(
    for eventId: Identifier,
    speakersCount: Int = 2,
    contentCount: Int = 2
  ) throws {
    let speech = Speech(
      eventId: eventId,
      title: String.randomValue,
      description: String.randomValue
    )
    try speech.save()
    
    for _ in 0..<speakersCount {
      let user = User(
        name: String.randomValue,
        lastname: String.randomValue,
        company: String.randomValue,
        position: String.randomValue,
        photo: String.randomValue,
        email: String.randomValue,
        phone: String.randomValue
      )
      try user.save()
      
      let speaker = Speaker(userId: user.id!, speechId: speech.id!)
      try speaker.save()
    }
    
    for _ in 0..<contentCount {
      let content = Content(
        speechId: speech.id!,
        title: String.randomValue,
        description: String.randomValue,
        link: String.randomValue,
        type: Bool.randomValue ? .video : .slide
      )
      try content.save()
    }
  }
}
