import Foundation
@testable import App
@testable import Vapor
import XCTest
import Testing
import FluentProvider

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
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

    let config = try! Config(arguments: ["vapor", "--env=test"])
    try config.setup()
    try recreateDatabase(config)
    let drop = try! Droplet(config)
    try drop.setup()
    return drop
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
