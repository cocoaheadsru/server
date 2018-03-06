import Vapor
import HTTP

final class PhotoURLMiddleware: Middleware {

  let domain: String

  init(_ domain: String) {
    self.domain = domain
  }

  func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    let response = try next.respond(to: request)

    if let array = response.json?.array {
      // this is Event
      
      let arrayWithPhotoURL = try array.map { (element) -> StructuredData in
        var result = element

        if let photoWithPath = element[User.Keys.photoURL]?.string {
          let photoURL = "\(domain)/\(photoWithPath)"
          try result.set(User.Keys.photoURL, photoURL)
        }

        if let speakersPhoto  = element[Event.Keys.speakersPhotos]?.array {

          let speakersPhotoURL = speakersPhoto.map { (speackerPhoto) -> String? in
            guard let photo = speackerPhoto.string else {
              return nil
            }

            let photoURL = "\(domain)/\(photo)"
            return photoURL
          }

          try result.set(Event.Keys.speakersPhotos, speakersPhotoURL)
        }

        return result.wrapped
      }

      response.json = JSON(.array(arrayWithPhotoURL))
      return response
    }

    if let photoWithPath = response.json?[User.Keys.photoURL]?.string {
      let photoURL = "\(domain)/\(photoWithPath)"
      try response.json?.set(User.Keys.photoURL, photoURL)
    }

    return response
  }

}

extension PhotoURLMiddleware: ConfigInitializable {

  convenience init(config: Config) throws {
    let constants = Constants.Config.self
    if let domain = config[constants.app, constants.domain]?.string.ifNotEmpty {
      self.init(domain)
    } else {
      throw MiddlewareError.missingDomain
    }
  }

}
