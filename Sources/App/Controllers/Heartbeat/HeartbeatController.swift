import Vapor
import HTTP

final class HeartbeatController  {
  
  func index(req: Request) throws -> ResponseRepresentable {
    guard let beat = try Heartbeat.all().first else {
      return Response.init(status: .noContent)
    }
    let result = try beat.makeJSON()
    return result
  }
  
  func store(req: Request) throws -> ResponseRepresentable {
    let count = try Heartbeat.count()
    if count > 0 {
      try Heartbeat.makeQuery().delete()
    }
    let json = req.json
    let value : Int = try json?.get("beat") ?? -1
    let beat = Heartbeat(beat: value)
    try beat.save()
    let result = try beat.makeJSON()
    return result
  }
}

extension HeartbeatController : ResourceRepresentable  {
  
  func makeResource() -> Resource<Heartbeat> {
    return Resource(
      index: index,
      store: store
    )
  }

  
}
