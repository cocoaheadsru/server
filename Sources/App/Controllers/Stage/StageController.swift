import Vapor
import HTTP

final class StageController {

  private let drop: Droplet

  init(drop: Droplet) {
    self.drop = drop

  }

  func store(request: Request) throws -> ResponseRepresentable {
    try drop.setupSamples()
    return try Response( .ok, message: "Stage was (re)created")
  }
}

extension StageController: ResourceRepresentable {

  func makeResource() -> Resource<Heartbeat> {
    return Resource(
      store: store
    )
  }
}
