import Foundation

extension String {
  static var randomValue: String {
    let uuid = UUID().uuidString
    let upperBound = UInt32(uuid.count - 1)
    let randomStringLength = Int(arc4random_uniform(upperBound)) + 1
    let randomStringIndex = String.Index(encodedOffset: randomStringLength)
    let randString = String(uuid[..<randomStringIndex])
    return randString
  }
}
