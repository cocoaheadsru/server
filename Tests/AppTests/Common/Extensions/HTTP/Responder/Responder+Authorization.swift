import Vapor
import HTTP
@testable import Vapor
@testable import App

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
//swiftlint:disable force_cast

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
    let request = Request.makeTest(
      method: method,
      headers: headers,
      body: body?.makeBody() ?? .data([]),
      hostname: hostname,
      path: path,
      query: query
    )

    request.headers[.host] = hostname
    request.headers[.contentType] = TestConstants.Header.Value.applicationJson

    return try self.testResponse(
      to: request,
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
    let token = droplet?.config["app", "client-token"]?.string

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
    line: UInt = #line,
    bearer token: String? = nil
    ) throws -> HTTP.Response {

    var userHeaders = headers
    var bearerToken = "Bearer "

    if let token = token {
      bearerToken += token
    } else if body != nil {
      let json =  body as! JSON
      let tokenFromBody = json["token"]?.string
      bearerToken += tokenFromBody!
    } else {
      let user = User()
      try! user.save()
      bearerToken += user.token!
    }

    userHeaders[HTTP.HeaderKey.authorization] = bearerToken
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
