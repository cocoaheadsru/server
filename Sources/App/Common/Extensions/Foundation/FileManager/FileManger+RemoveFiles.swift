import Foundation

extension FileManager {

  func removeAllFiles(atPath: String) throws {

    guard fileExists(atPath: atPath) else {
      return
    }

    try contentsOfDirectory(atPath: atPath).forEach { filename in
      let filePathToRemove = atPath + filename
      try removeItem(atPath: filePathToRemove)
    }

  }

  func removeAllFiles(at dir: URL) throws {

    guard fileExists(atPath: dir.path) else {
      return
    }

    try contentsOfDirectory(atPath: dir.path).forEach { filename in
      let filePathToRemove = dir.appendingPathComponent(filename)
      try removeItem(at: filePathToRemove)
    }

  }

}
