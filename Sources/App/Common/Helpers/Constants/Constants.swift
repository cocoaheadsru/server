import HTTP

struct Constants {
  
  struct Config {
    static let server = "server"
    static let clientToken = "client-token"
  }
  
  struct Header {
    
    struct Key {
      static let clientToken: HeaderKey = "client-token"
      static let contentType: HeaderKey = "Content-Type"
      static let userToken: HeaderKey = "user-token"
    }
    
    struct Value {
      static let applicationJson = "application/json"
    }
  }

  struct Middleware {
    static let client = "client-middleware"
  }
}
