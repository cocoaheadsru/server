import Vapor
import HTTP

typealias HTTPHeader = [HTTP.HeaderKey: String]

extension Responder {
  public func unauthorizedTestResponse(
    to method: HTTP.Method,
    at path: String,
    query: String? = nil,
    hostname: String = "0.0.0.0",
    headers: [HTTP.HeaderKey: String] = [:],
    body: BodyRepresentable? = nil,
    file: StaticString = #file,
    line: UInt = #line
    ) throws -> HTTP.Response {
    let req = Request.makeTest(
      method: method,
      headers: headers,
      body: body?.makeBody() ?? .data([]),
      hostname: hostname,
      path: path,
      query: query
    )

    req.headers[.host] = hostname
    req.headers[.contentType] = TestConstants.Header.Value.applicationJson

    return try self.testResponse(
      to: req,
      file: file,
      line: line
    )
  }
  
  public func clientAuthorizedTestResponse(
    to method: HTTP.Method,
    at path: String,
    query: String? = nil,
    hostname: String = "0.0.0.0",
    headers: [HTTP.HeaderKey: String] = [:],
    body: BodyRepresentable? = nil,
    file: StaticString = #file,
    line: UInt = #line
    ) throws -> HTTP.Response {

    let droplet = self as? Droplet
    let token = droplet?.config["server", "client-token"]?.string

    var appHeaders = headers
    appHeaders["client-token"] = token
    if appHeaders[TestConstants.Header.Key.contentType] == nil {
      appHeaders[TestConstants.Header.Key.contentType] = TestConstants.Header.Value.applicationJson
    }
    return try self.unauthorizedTestResponse(
      to: method,
      at: path,
      query: query,
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
    query: String? = nil,
    hostname: String = "0.0.0.0",
    headers: [HTTP.HeaderKey: String] = [:],
    body: BodyRepresentable? = nil,
    file: StaticString = #file,
    line: UInt = #line
    ) throws -> HTTP.Response {
    let userHeaders = headers
    return try self.clientAuthorizedTestResponse(
      to: method,
      at: path,
      query: query,
      hostname: hostname,
      headers: userHeaders,
      body: body,
      file: file,
      line: line
    )
  }
}
