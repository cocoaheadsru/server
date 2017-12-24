import HTTP

final class ResponderStub: Responder {
  let status: Status
  init(_ status: Status = .ok) {
    self.status = status
  }
  func respond(to request: Request) throws -> Response {
    return Response(status: status)
  }
}
