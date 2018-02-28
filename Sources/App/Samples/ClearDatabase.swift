import Foundation

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
extension Droplet {

   public func truncateTables() throws {

    var _tableList: [String]?

    var tableForTruncate: [String] {

      if _tableList != nil {
        return _tableList!
      }

      let db = try! self.assertDatabase()
      // swiftlint:disable force_try
      guard let nodes = try! db.driver.makeConnection(.read).raw("SHOW TABLES;").array else {
        return []
      }

      let jsons = nodes.map { (node) -> JSON in
        return JSON(node: node)
      }

      let dbName = self.config["mysql", "database"]?.string ?? ""
      _tableList = jsons
        .map { (json) -> String in
          json["Tables_in_\(dbName)"]?.string ?? ""
        }
        .filter({ (table) -> Bool in
          table != "social" &&
          table != "fluent"
        })

      return _tableList!
    }

    guard self.config.environment == .development else {
      return
    }

    let db = try! self.assertDatabase()

    defer {
      // swiftlint:disable force_try
      try! db.raw("SET FOREIGN_KEY_CHECKS = 1;")
      print("Foreign key checks ON\n")
    }

    try! db.raw("SET FOREIGN_KEY_CHECKS = 0;")
    print("\nForeign key checks OFF")

    var truncatedTableCount = 0

    tableForTruncate.forEach { (table) in
      try! db.raw("TRUNCATE \(table)")
      truncatedTableCount += 1
    }

    print("Truncate table(s): \(truncatedTableCount)")

  }
}
