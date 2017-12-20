import Foundation

extension Array {
  var  randomValue: Element {
    let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
    return self[randomIndex]
  }
}
