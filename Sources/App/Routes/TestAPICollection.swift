import Vapor
import HTTP
import Routing
import AuthProvider

final class TestAPICollection: RouteCollection {

  let drop: Droplet
  let config: Config

  init(drop: Droplet) {
    self.drop = drop
    self.config = drop.config
  }
  
  func build(_ builder: RouteBuilder) throws {

    let testAPI = builder.grouped("test")

    try testAPI.resource("heartbeat", HeartbeatController.self)

    let stageController = StageController(drop: drop)
    testAPI.resource("stage/recreate", stageController)

    let clientMiddlewareGroup = testAPI.grouped([
      try ClientMiddleware(config: config),
      try PhotoURLMiddleware(config: config)
    ])

    clientMiddlewareGroup.get("hello") { _ in
      var json = JSON()
      try json.set("hello", "world")
      return json
    }

    clientMiddlewareGroup.get("plaintext") { _ in
      return "Hello, world!"
    }
    
  }

}
