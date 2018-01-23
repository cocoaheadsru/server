import Foundation
#if os(Linux)
import libc
#endif
extension Double {
  /// Random double value,
  /// rounded to 4 places, for ex: 1.212233244 -> 1.2122
  static var randomValue: Double {
    let r = random(min: 1.111, max: 333.333)
    let divisor = pow(10.0, 4.0)
    #if os(Linux)
      return libc.round(r * divisor) / divisor
    #else
      return Darwin.round(r * divisor) / divisor
    #endif
  }

  static func random(min: Double, max: Double) -> Double {
    let bigRand = Int.random(min: 0, max: Int(Int32.max)-1)
    // Random number from 0 to 1.0, inclusive
    let random = Double(bigRand) / 0xFFFFFFFF
    return random * (max - min) + min
  }
}
