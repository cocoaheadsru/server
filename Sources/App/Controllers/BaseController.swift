import Vapor
import FluentProvider

protocol BaseController {
  associatedtype Resource: Model, JSONConvertible, ResponseRepresentable
}

enum Method {
  case index
  case show
  case create
  case destroy
}

extension BaseController {
  
  func addRoutes(to droplet: Droplet, namespace: String? = nil, only methods: [Method] = [.index, .show, .create, .destroy]) {
    let modelRoute = namespace ?? String(describing: Resource.self).lowercased()
    let resourceGroup = droplet.grouped(modelRoute)
    for method in methods {
      switch method {
      case .index:
        resourceGroup.get(handler: index)
      case .show:
        resourceGroup.get(Resource.parameter, handler: show)
      case .create:
        resourceGroup.post(handler: create)
      case .destroy:
        resourceGroup.delete(Resource.parameter, handler: destroy)
      }
    }
  }
  
  func index(_ request: Request) throws -> ResponseRepresentable {
    let resources = try Resource.all()
    return try resources.makeJSON()
  }
  
  func show(_ request: Request) throws -> ResponseRepresentable {
    let resource = try request.parameters.next(Resource.self)
    return resource
  }
  
  func create(_ request: Request) throws -> ResponseRepresentable {
    guard let json = request.json else {
      throw Abort.badRequest
    }
    let resource = try Resource(json: json)
    try resource.save()
    return resource
  }
  
  func destroy(_ request: Request) throws -> ResponseRepresentable {
    let resource = try request.parameters.next(Resource.self)
    try resource.delete()
    return JSON()
  }
}
