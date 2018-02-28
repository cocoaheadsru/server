import HTTP

struct TestConstants {
  
  struct Middleware {
    static let validToken = "test"
  }
  
  struct Header {
    
    struct Key {
      static let clientToken: HeaderKey = "client-token"
      static let contentType: HeaderKey = "Content-Type"
      static let userToken: HeaderKey = "user-token"
    }
    
    struct Value {
      static let applicationJson = "application/json"
      static let multipartFormData = "multipart/form-data"
    }
  }
  
  struct Path {
    static let userPhotosPath = "user_photos/"
  }
  
}
