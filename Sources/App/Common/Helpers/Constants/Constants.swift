import HTTP

final class Constants {
  struct Config {
    static var server = "server"
    static var clientToken = "client-token"
    static var clientTokenHeader: HeaderKey = "client-token"
  }
  struct Middleware {
    static var client = "client-middleware"
  }
}
