import Vapor
import FluentProvider

final class CreatorsController {

  func getAllCreators(_ request: Request) throws -> ResponseRepresentable {
    return try Creator.all().makeJSON()
  }

}

extension CreatorsController: ResourceRepresentable {

  func makeResource() -> Resource<Creator> {
    return Resource(
      index: getAllCreators
    )
  }
}

extension CreatorsController: EmptyInitializable { }
