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
    
    try resource("heartbeat", HeartbeatController.self)
    try resource("event", EventController.self)
    try resource("event/:id/speech", EventSpeechController.self)
  }
}
