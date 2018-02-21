import HTTP
import AuthProvider

extension Request {
  func user() throws -> User {
    return try auth.assertAuthenticated()
  }
}
