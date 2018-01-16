import Foundation

extension Int {
  static var randomValue: Int {
    return Int.random(min: 0, max: 1000)
  }
  
  static var randomTimestamp: Int {
    return Int.random(min: 50000, max: 500000)
  }
}
