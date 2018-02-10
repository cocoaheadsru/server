import Crypto
@testable import Vapor

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
extension CryptoHasher {

  static func compareFiles(filePath1: String, filePath2: String) throws -> Bool {
    let file1 = try! Vapor.FileManager.readBytesFromFile(filePath1)
    let file2 = try! Vapor.FileManager.readBytesFromFile(filePath2)

    let md5 = CryptoHasher(hash: .md5, encoding: .hex)

    let file1MD5 = try md5.make(file1).makeString()
    let file2MD5 = try md5.make(file2).makeString()

    return file1MD5 == file2MD5
  }

}
