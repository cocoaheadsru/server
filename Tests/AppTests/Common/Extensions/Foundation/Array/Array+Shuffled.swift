import Foundation

extension Array {
  func shuffled() -> [Element] {
    guard count > 1 else {
      return self
    }
    var result = self
    for i in 0..<(result.count - 1) {
      let j = Int(arc4random_uniform(UInt32(result.count - i))) + i
      result.swapAt(i,j)
    }
    return result
  }
}
