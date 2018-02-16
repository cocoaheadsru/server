import Foundation
import XCTest
import Testing
import FluentProvider
@testable import App
@testable import Vapor

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try

var drop: Droplet! = try? Droplet.testable()

private var _tableList: [String]?

private var tableForTruncate: [String] {

  if _tableList != nil {
    return _tableList!
  }

  let db = try! drop.assertDatabase()

  guard let nodes = try! db.driver.makeConnection(.read).raw("SHOW TABLES;").array else {
    XCTFail("Can't get tables list")
    return []
  }

  let jsons = nodes.map { (node) -> JSON in
    return JSON(node: node)
  }

  let dbName = drop.config["mysql", "database"]?.string ?? ""
  _tableList = jsons
    .map { (json) -> String in
      json["Tables_in_\(dbName)"]?.string ?? ""
    }
    .filter({ (table) -> Bool in
      table != "social"
    })

  return _tableList!
}

extension Droplet {
  static func testable() throws -> Droplet {
    
    func recreateDatabase(_ config: Config) throws {
      let dbName = config["mysql", "database"]?.string ?? ""
      let driver = try! config.resolveDriver()
      let connection = try! driver.makeConnection(.readWrite)
      try! connection.raw("DROP DATABASE IF EXISTS \(dbName)")
      print("Database '\(dbName)' successfully dropped")
      try! connection.raw("CREATE DATABASE \(dbName)")
      print("Database '\(dbName)' successfully created")
    }

    let config = try Config(arguments: ["vapor", "--env=test"])
    try config.setup()
    try recreateDatabase(config)
    let drop = try Droplet(config)
    try drop.setup()
    return drop
  }

  func truncateTables() throws {
    let db = try! self.assertDatabase()

    defer {
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

  func serveInBackground() throws {
    background {
      //swiftlint:disable force_try
      try! self.run()
      //swiftlint:enable force_try
    }
    console.wait(seconds: 0.5)
  }
}

class TestCase: XCTestCase {
  override func setUp() {
    Node.fuzzy = [Row.self, JSON.self, Node.self]
    Testing.onFail = XCTFail
  }
}
