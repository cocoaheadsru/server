import Foundation

extension Bool {
  static var randomValue: Bool {
    return Int.random(min: 0, max: 1) == 0
  }
}
