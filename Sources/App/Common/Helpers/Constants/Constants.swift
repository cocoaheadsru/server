import HTTP

struct Constants {
  
  struct Config {
    static let app = "app"
    static let clientToken = "client-token"
    static let domain = "domain"
  }
  
  struct Header {
    struct Value {
      static let applicationJson = "application/json"
    }
  }

  struct Middleware {
    static let client = "client-middleware"
  }
  
  struct Path {
    static let userPhotos = "user_photos"
    static let creatorsPhotos = "creator_photos"
  }

  struct Status {
    struct Registration {
      static let closed = "registration_closed"
      static let canRegister = "can_register"
    }
  }

}
