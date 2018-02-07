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
    if
      let userId = user.id?.string,
      let bytes = request.formData?["photo"]?.bytes,
      let filename = request.formData?["photo"]?.filename {
      try savePhoto(for: userId, photoBytes: bytes, filename: filename)
    }
    try user.update(for: request)
    try user.save()
    return user
  }
  
  func updateSessionToken(for user: User) throws {
    do {
      try user.session()?.updateToken()
    } catch {
      throw Abort.badRequest
    }
  }
  
  func savePhoto(for userId: String, photoBytes: [UInt8], filename: String) throws {
    let userDir = URL(fileURLWithPath: droplet.config.publicDir)
      .appendingPathComponent("user_photos")
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
