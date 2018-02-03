import Vapor
import FluentProvider
import Foundation

final class UserController {
  
  let droplet: Droplet!
  
  init(droplet: Droplet) {
    self.droplet = droplet
  }

  func show(_ request: Request, user: User) throws -> ResponseRepresentable {
    try updateSessionToken(for: user)
    return user
  }

  func update(_ request: Request, user: User) throws -> ResponseRepresentable {
    try updateSessionToken(for: user)
    try user.update(for: request)
    if
      let userId = user.id?.string,
      let bytes = request.formData?["photo"]?.bytes,
      let filename = request.formData?["photo"]?.filename {
      try user.photo = newPhotoURL(for: userId, photoBytes: bytes, filename: filename)
    }
    try user.save()
    return user
  }
  
  func updateSessionToken(for user: User) throws {
    do {
      try user.updateSessionToken()
    } catch {
      throw Abort.badRequest
    }
  }
  
  func newPhotoURL(for userId: String, photoBytes: [UInt8], filename: String) throws -> String {
    let userDir = URL(fileURLWithPath: droplet.config.workDir)
      .appendingPathComponent("images")
      .appendingPathComponent("user_photos")
      .appendingPathComponent(userId)
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: userDir.path) {
      let filePathes = try fileManager.contentsOfDirectory(atPath: userDir.path)
      for path in filePathes {
        let fullURL = userDir.appendingPathComponent(path)
        try fileManager.removeItem(at: fullURL)
      }
    } else {
      try fileManager.createDirectory(at: userDir, withIntermediateDirectories: true, attributes: nil)
    }
    let userDirWithImage = userDir.appendingPathComponent(filename)
    let data = Data(bytes: photoBytes)
    fileManager.createFile(atPath: userDirWithImage.path, contents: data, attributes: nil)
    
    return userDirWithImage.path
  }
}

extension UserController: ResourceRepresentable {

  func makeResource() -> Resource<User> {
    return Resource(
      show: show,
      update: update
    )
  }
}

extension UserController: EmptyInitializable {
  convenience init() throws {
    try self.init()
  }
}
