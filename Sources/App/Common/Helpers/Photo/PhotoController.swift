import Foundation
import HTTP
import Vapor
import FluentProvider

struct PhotoConroller {

  private let drop: Droplet

  init(drop: Droplet) {
    self.drop = drop
  }

  func downloadAndSavePhoto(for user: User, by url: String?) throws -> String {

    guard
      let photoURL = url,
      !photoURL.isEmpty,
      let userId = user.id?.string
    else {
        throw Abort(.badRequest, reason: "Can't get photo from url: '\(url ?? "empty URL")'")
    }
    return try downloadAndSavePhoto(for: userId, by: photoURL)
  }

  func downloadAndSavePhoto(for userId: String, by url: String) throws -> String {

    let request = try drop.client.get(url)
    guard let photoBytes = request.body.bytes else {
      throw Abort(.badRequest, reason: "Can't get photo from url: '\(url)'")
    }

    guard let photoURL = URL(string: url) else {
      throw Abort(.badRequest, reason: "Can't cast String to URL for: '\(url)'")
    }

    let filename = photoURL.lastPathComponent
    try savePhoto(for: userId, photoBytes: photoBytes, filename: filename)

    return filename
  }

  func savePhoto(for userId: String, photoAsString: String) throws -> String {

    let filename = UUID().uuidString + ".png"

    guard let photo = Data(base64Encoded: photoAsString) else {
      throw Abort(.badRequest, reason: "Can't cast photoAsString to Data")
    }

    let photoBytes = photo.makeBytes()
    try savePhoto(for: userId, photoBytes: photoBytes, filename: filename)

    return filename
  }

  func savePhoto(for userId: String, photoBytes: Bytes, filename: String) throws {

    let userDir = URL(fileURLWithPath: drop.config.publicDir)
      .appendingPathComponent(Constants.Path.userPhotos)
      .appendingPathComponent(userId)

    let fileManager = FileManager.default

    if fileManager.fileExists(atPath: userDir.path) {
      let filenames = try fileManager.contentsOfDirectory(atPath: userDir.path)
      for name in filenames {
        let fileURL = userDir.appendingPathComponent(name)
        try fileManager.removeItem(at: fileURL)
      }
    } else {
      try fileManager.createDirectory(at: userDir, withIntermediateDirectories: true, attributes: nil)
    }
    
    let userDirWithImage = userDir.appendingPathComponent(filename)
    let data = Data(bytes: photoBytes)
    fileManager.createFile(atPath: userDirWithImage.path, contents: data, attributes: nil)
  }

}
