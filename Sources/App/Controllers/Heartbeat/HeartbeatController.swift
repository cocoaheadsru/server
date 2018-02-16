import Vapor
import HTTP

final class HeartbeatController {
  
  func index(request: Request) throws -> ResponseRepresentable {
    guard let beat = try Heartbeat.all().first else {
      return Response(status: .noContent)
    }
    let result = try beat.makeJSON()
    return result
  }
  
  func store(request: Request) throws -> ResponseRepresentable {
    let count = try Heartbeat.count()
    if count > 0 {
      try Heartbeat.makeQuery().delete()
    }
    guard let json = request.json else {
      return try Response(status: .badRequest, message: "JSON is missing")
    }
    let beat = try Heartbeat(json: json)
    try beat.save()
    return try beat.makeJSON()
  }
}

extension HeartbeatController: ResourceRepresentable {
  
  func makeResource() -> Resource<Heartbeat> {
    return Resource(
      index: index,
      store: store
    )
  }
}

extension HeartbeatController: EmptyInitializable {}
