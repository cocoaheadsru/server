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
  
  static var randomURL: String {
    if Bool.randomValue {
      return "https://\(String.randomValue).\(String.randomValue).\(String.randomValue)"
    } else {
      return "http://\(String.randomValue).\(String.randomValue).\(String.randomValue)"
    }
  }
  
  static var randomPhotoName: String {
    if Bool.randomValue {
      return  "\(String.randomValue).png"
    } else {
      return  "\(String.randomValue).jpeg"
    }
  }
  
  static var randomEmail: String {
    if Bool.randomValue {
      return  "\(String.randomValue)/@\(String.randomValue).com"
    } else {
      return  "\(String.randomValue)/@\(String.randomValue).org"
    }
  }
  
  static var randomPhone: String {
    let country = "\(Int.randomValue(min: 1, max: 99))"
    let region = "(\(Int.randomValue(min: 100, max: 999)))"
    let city = "\(Int.randomValue(min: 100, max: 999))"
    let building = "\(Int.randomValue(min: 100, max: 999))"
    return  "+" + country + "-" + region + "-" + city + "-" + building
  }
  
}
