import Foundation

extension Array {
  var randomValue: Element {
    let randomIndex = Int.random(min: 0, max: self.count - 1)
    return self[randomIndex]
  }
}
