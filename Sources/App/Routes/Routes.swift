import Vapor

extension Droplet {
  func setupRoutes() throws {
    get("hello") { req in
      var json = JSON()
      try json.set("hello", "world")
      return json
    }
    
    get("plaintext") { req in
      return "Hello, world!"
    }
    
    let heartbeat = HeartbeatController()
    resource("heartbeat",heartbeat)
    
  }
}
