import HTTP

extension Responder {
  public func unauthorizedTestResponse(
    to method: HTTP.Method,
    at path: String,
    hostname: String = "0.0.0.0",
    headers: [HTTP.HeaderKey : String] = [:],
    body: BodyRepresentable? = nil,
    file: StaticString = #file,
    line: UInt = #line
    ) throws -> HTTP.Response {
    return try self.testResponse(
      to: method,
      at: path,
      hostname: hostname,
      headers: headers,
      body: body,
      file: file,
      line: line
    )
  }
  
  public func appAuthorizedTestResponse(
    to method: HTTP.Method,
    at path: String,
    hostname: String = "0.0.0.0",
    headers: [HTTP.HeaderKey : String] = [:],
    body: BodyRepresentable? = nil,
    file: StaticString = #file,
    line: UInt = #line
    ) throws -> HTTP.Response {
    var appHeaders = headers
    appHeaders["client-token"] = "test"
    return try self.unauthorizedTestResponse(
      to: method,
      at: path,
      hostname: hostname,
      headers: appHeaders,
      body: body,
      file: file,
      line: line
    )
  }
  
  public func userAuthorizedTestResponse(
    to method: HTTP.Method,
    at path: String,
    hostname: String = "0.0.0.0",
    headers: [HTTP.HeaderKey : String] = [:],
    body: BodyRepresentable? = nil,
    file: StaticString = #file,
    line: UInt = #line
    ) throws -> HTTP.Response {
    var userHeaders = headers
    userHeaders["user-token"] = "user"
    return try self.appAuthorizedTestResponse(
      to: method,
      at: path,
      hostname:
      hostname,
      headers: userHeaders,
      body: body,
      file: file,
      line: line
    )
  }
}
