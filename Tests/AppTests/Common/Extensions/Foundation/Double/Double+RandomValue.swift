import Foundation

extension Double {
  static var randomValue: Double {
    return Double(arc4random_uniform(100000)) / Double(arc4random_uniform(1000))
  }
}
