import Foundation

extension Double {
  /// Random double value,
  /// rounded to 4 places, for ex: 1.212233244 -> 1.2122
  static var randomValue: Double {
    let r = random(min: 1.111, max: 333.333)
    let divisor = pow(10.0, 4.0)
    return Darwin.round(r * divisor) / divisor
  }

  static func random(min: Double, max: Double) -> Double {
    // Random number from 0 to 1.0, inclusive
    let random = Double(arc4random()) / 0xFFFFFFFF
    return random * (max - min) + min
  }
}
