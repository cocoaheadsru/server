import Vapor
import HTTP

final class StageController {

  private let sample: Samples

  init(drop: Droplet) {
    self.sample = Samples(drop: drop)
  }

  func store(request: Request) throws -> ResponseRepresentable {
    try sample.create()
    return try Response( .ok, message: "Stage was recreated")
  }
}

extension StageController: ResourceRepresentable {

  func makeResource() -> Resource<Heartbeat> {
    return Resource(
      store: store
    )
  }
}
