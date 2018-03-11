import Foundation
import HTTP
import Vapor
import FluentProvider

struct PhotoController {

  private let drop: Droplet

  init(drop: Droplet) {
    self.drop = drop
  }

  func downloadAndSavePhoto(for event: Event, with url: String?) throws -> String {

    guard
      let photoURL = url,
      photoURL.isNotEmpty,
      let eventId = event.id?.string
    else {
      throw Abort(.badRequest, reason: "Can't get photo from url: '\(url ?? "empty URL")'")
    }
    return try downloadAndSavePhoto(for: eventId, with: photoURL, folder: Constants.Path.eventPhotos)
  }

  func downloadAndSavePhoto(for user: User, with url: String?) throws -> String {

    guard
      let photoURL = url,
      photoURL.isNotEmpty,
      let userId = user.id?.string
    else {
        throw Abort(.badRequest, reason: "Can't get photo from url: '\(url ?? "empty URL")'")
    }
    return try downloadAndSavePhoto(for: userId, with: photoURL)
  }

  func downloadAndSavePhoto(for objectId: String, with url: String, folder: String = Constants.Path.userPhotos) throws -> String {

    let request = try drop.client.get(url)
    guard let photoBytes = request.body.bytes else {
      throw Abort(.badRequest, reason: "Can't get photo from url: '\(url)'")
    }

    guard let photoURL = URL(string: url) else {
      throw Abort(.badRequest, reason: "Can't cast String to URL for: '\(url)'")
    }

    let filename = photoURL.lastPathComponent
    try savePhoto(for: objectId, photoBytes: photoBytes, filename: filename, folder: folder)

    return filename
  }

  func savePhoto(for objectId: String, photoAsString: String, folder: String = Constants.Path.userPhotos) throws -> String {

    let filename = UUID().uuidString + ".png"

    guard let photo = Data(base64Encoded: photoAsString) else {
      throw Abort(.badRequest, reason: "Can't cast photoAsString to Data")
    }

    let photoBytes = photo.makeBytes()
    try savePhoto(for: objectId, photoBytes: photoBytes, filename: filename, folder: folder)

    return filename
  }

  func savePhoto(for objectId: String, photoBytes: Bytes, filename: String, folder: String = Constants.Path.userPhotos) throws {

    let userDir = URL(fileURLWithPath: drop.config.publicDir)
      .appendingPathComponent(folder)
      .appendingPathComponent(objectId)

    let fileManager = FileManager.default

    if fileManager.fileExists(atPath: userDir.path) {
      try fileManager.removeAllFiles(at: userDir)
    } else {
      try fileManager.createDirectory(at: userDir, withIntermediateDirectories: true, attributes: nil)
    }
    
    let userDirWithImage = userDir.appendingPathComponent(filename)
    let data = Data(bytes: photoBytes)
    fileManager.createFile(atPath: userDirWithImage.path, contents: data, attributes: nil)
  }

}
