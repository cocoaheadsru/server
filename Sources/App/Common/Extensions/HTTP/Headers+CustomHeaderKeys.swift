import Vapor
import HTTP

extension HTTP.KeyAccessible where Key == HeaderKey, Value == String {
  
  var clientToken: String? {
    get {
      return self["client-token"]
    }
    set {
      self["client-token"] = newValue
    }
  }
  
  var contentType: String? {
    get {
      return self["Content-Type"]
    }
    set {
      self["Content-Type"] = newValue
    }
  }
  
  var userToken: String? {
    get {
      return self["user-token"]
    }
    set {
      self["user-token"] = newValue
    }
  }

}
