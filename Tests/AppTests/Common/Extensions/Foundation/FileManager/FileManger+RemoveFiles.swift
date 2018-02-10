import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
extension FileManager {

  func removeAllFiles(atPath: String) throws {
    guard self.fileExists(atPath: atPath) else {
      return
    }

    let filenames = try! self.contentsOfDirectory(atPath: atPath)

    for name in filenames {
      let fileForRemove = atPath + name
      try! self.removeItem(atPath: fileForRemove)
    }

  }

}
