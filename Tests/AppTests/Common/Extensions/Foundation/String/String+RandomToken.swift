import Foundation

extension String {    
  static var invalidRandomToken: String {
    let token = String.randomValue
    if ["test", "user"].contains(token) {
      return self.invalidRandomToken
    }
    return token
  }
}
