import Vapor
@testable import App
//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
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
    let speech = Speech(eventId: eventId)
    try! speech.save()
    
    for _ in 0..<speakersCount {
      let user = User()
      try! user.save()
      
      let speaker = Speaker(userId: user.id!, speechId: speech.id!)
      try! speaker.save()
    }
    
    for _ in 0..<contentCount {
      let content = App.Content(speechId: speech.id!)
      try! content.save()
    }
  }
  
}
