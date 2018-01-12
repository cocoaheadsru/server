import Foundation

extension String {
  static var randomValue: String {
    let uuid = UUID().uuidString
    let upperBound = uuid.count - 1
    let randomStringLength = Int.random(min: 1, max: upperBound)
    let randomStringIndex = String.Index(encodedOffset: randomStringLength)
    let randString = String(uuid[..<randomStringIndex])
    return randString
  }
}
