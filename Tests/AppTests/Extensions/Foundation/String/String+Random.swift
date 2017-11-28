import Foundation

extension String {
  static var random: String {
    let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let allowedCharsCount = UInt32(allowedChars.count)
    var randomString = ""
    let randomStringLength = Int(arc4random_uniform(32))
    
    for _ in 0 ..< randomStringLength {
      let randomNum = Int(arc4random_uniform(allowedCharsCount))
      let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
      let newCharacter = allowedChars[randomIndex]
      randomString += String(newCharacter)
    }
    
    return randomString
  }
  
  static var randomToken: String {
    let token = String.random
    guard !["test", "user"].contains(token) else {
      return String.randomToken
    }
    return token
  }
}
