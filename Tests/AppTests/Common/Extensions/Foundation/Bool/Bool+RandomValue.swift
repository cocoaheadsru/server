import Foundation

extension Bool {
  static var randomValue: Bool {
    return arc4random_uniform(2) == 0
  }
}
