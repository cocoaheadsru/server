import Foundation

extension FileManager {

  func removeAllFiles(atPath: String) throws {

    guard self.fileExists(atPath: atPath) else {
      return
    }

    try self.contentsOfDirectory(atPath: atPath).forEach { (filename) in
      let fileForRemove = atPath + filename
      try self.removeItem(atPath: fileForRemove)
    }

  }

  func removeAllFiles(at dir: URL) throws {

    guard self.fileExists(atPath: dir.path) else {
      return
    }

    try self.contentsOfDirectory(atPath: dir.path).forEach { (filename) in
      let fileForRemove = dir.appendingPathComponent(filename)
      try self.removeItem(at: fileForRemove)
    }

  }

}
