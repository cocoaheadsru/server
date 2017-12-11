import Foundation

extension String {
  
  static var randomString: String {
    let uuid = UUID().uuidString
    let upperBound = UInt32(uuid.count - 1)
    let randomStringLength = Int(arc4random_uniform(upperBound)) + 1
    let randomStringIndex = String.Index(encodedOffset: randomStringLength)
    let randString = String(uuid[..<randomStringIndex])
    return randString
  }
    
  static var invalidRandomToken: String {
    let token = String.randomString
    if ["test", "user"].contains(token) {
      return self.invalidRandomToken
    }
    return token
  }
}
