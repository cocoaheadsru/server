import Foundation

extension Date {
  static var randomValue: Date {
    let randomTimelane: Double = Bool.randomValue ? 1 : -1
    let positiveInterval = randomTimelane * Double.random(min: 30000, max: 1000000)
    return Date().addingTimeInterval(positiveInterval)
  }
  
  static var randomValueInFuture: Date {
    let positiveInterval = Double.random(min: 30000, max: 1000000)
    return Date().addingTimeInterval(positiveInterval)
  }
  
  static var randomValueInPast: Date {
    let negativeInterval = -1 * Double.random(min: 30000, max: 1000000)
    return Date().addingTimeInterval(negativeInterval)
  }
  
  var fiveHoursAgo: Date {
    let negativeFiveHourseInterval: Double = -18000
    return self.addingTimeInterval(negativeFiveHourseInterval)
  }

}
