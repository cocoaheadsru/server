import HTTP

struct Constants {
  
  struct Config {
    static let server = "server"
    static let clientToken = "client-token"
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
  }
}
