import Foundation

extension Array {
  func shuffled() -> [Element] {
    guard count > 1 else {
      return self
    }
    var result = self
    for i in 0..<(result.count - 1) {
      let j = Int.random(min: 0, max: result.count - 1 - i) + i
      result.swapAt(i, j)
    }
    return result
  }
}
