import Vapor
import FluentProvider
import Foundation
import Multipart

final class UserController {
  
  let photoController: PhotoController
  
  init(drop: Droplet) {
    photoController = PhotoController(drop: drop)
  }

  func show(_ request: Request, user: User) throws -> ResponseRepresentable {
    try updateSessionToken(for: user)
    return user
  }

  func update(_ request: Request, user: User) throws -> ResponseRepresentable {

    let photo = try updatePhoto(by: request, for: user)
    try user.update(for: request)
    if photo != nil {
      user.photo = photo
    }
    try user.save()
    try updateSessionToken(for: user)
    return user
  }
  
  func updateSessionToken(for user: User) throws {
    do {
      try user.updateSessionToken()
    } catch {
      throw Abort.badRequest
    }
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

extension UserController {

  func updatePhoto(by request: Request, for user: User) throws -> String? {

    guard let userId = user.id?.string else {
      throw Abort.badRequest
    }

    // get photo from formData
    if
      let bytes = request.formData?[RequestKeys.photo]?.bytes,
      let filename = request.formData?[RequestKeys.photo]?.filename {
      try photoController.savePhoto(for: userId, photoBytes: bytes, filename: filename)
      return filename
    }

    // get photo from body as base64EncodedString
    if let photoString = request.json?[RequestKeys.photo]?.string {
      return try photoController.savePhoto(for: userId, photoAsString: photoString)
    }

    // get photo by url download
    if let photoURL = request.json?[RequestKeys.photoURL]?.string {
      return try photoController.downloadAndSavePhoto(for: userId, with: photoURL)
    }

    return nil
  }

}

extension UserController {

  struct RequestKeys {
    static let photo = "photo"
    static let photoURL = "photoURL"
  }

}
