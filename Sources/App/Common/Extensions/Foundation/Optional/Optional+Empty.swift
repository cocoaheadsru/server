import Foundation

extension Optional where Wrapped == String {
  var ifNotEmpty: String? {
    if let value = self, !value.isEmpty {
      return value
    }
    return nil
  }
}
