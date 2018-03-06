import HTTP

struct Constants {
  
  struct Config {
    static let app = "app"
    static let clientToken = "client-token"
    static let domain = "domain"
  }

  struct Middleware {
    static let client = "client-middleware"
    static let photoURL = "photoURL-middleware"
  }
  
  struct Path {
    static let userPhotos = "user_photos"
    static let eventPhotos = "event_photos"
  }

  struct Status {
    struct Registration {
      static let closed = "registration_closed"
      static let canRegister = "can_register"
    }
  }

}
