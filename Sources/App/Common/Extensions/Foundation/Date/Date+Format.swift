import Foundation

extension Date {
  var mysqlString: String {
    return DateFormatter.mysql.string(from: self)
  }
}
