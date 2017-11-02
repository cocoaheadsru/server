struct ClientController {
  
  func addRoutes(to droplet: Droplet) {
    droplet.get("user", User.parameter, "client", handler: index)
    droplet.get("user", User.parameter, "client", Client.parameter, handler: show)
    droplet.post("user", User.parameter, "client", handler: create)
    droplet.patch("user", User.parameter, "client", Client.parameter, handler: update)
  }
  
  func validClient(_ request: Request) throws -> Client? {
    let user = try request.parameters.next(User.self)
    let client = try request.parameters.next(Client.self)
    if client.userId == user.id {
      return client
    }
    return nil
  }
  
  func index(_ request: Request) throws -> ResponseRepresentable {
    let user = try request.parameters.next(User.self)
    let clients = try user.clients.all()
    return try clients.makeJSON()
  }
  
  func show(_ request: Request) throws -> ResponseRepresentable {
    guard let client = try validClient(request) else {
      throw Abort.badRequest
    }
    return client
  }
  
  func create(_ request: Request) throws -> ResponseRepresentable {
    guard let _ = request.json else {
      throw Abort.badRequest
    }
    let client = try Client(request: request)
    try client.save()
    return client
  }
  
  func update(_ request: Request) throws -> ResponseRepresentable {
    guard let _ = request.json else {
      throw Abort.badRequest
    }
    guard let client = try validClient(request) else {
      throw Abort.badRequest
    }
    try client.update(for: request)
    try client.save()
    return client
  }
}
