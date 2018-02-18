import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: Preparation, ResponseRepresentable
final class Creator: Model {
    
  let storage = Storage()
  
  var userId: Identifier
  var position: Int
  var photoUrl: String
  var info: String
  var url: String
  var active: Bool
  
  init(userId: Identifier,
       position: Int,
       photoUrl: String,
       info: String,
       url: String,
       active: Bool) {
    self.userId = userId
    self.position = position
    self.photoUrl = photoUrl
    self.info = info
    self.url = url
    self.active = active
  }
  
  // sourcery:inline:auto:Creator.AutoModelGeneratable
  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    position = try row.get(Keys.position)
    photoUrl = try row.get(Keys.photoUrl)
    info = try row.get(Keys.info)
    url = try row.get(Keys.url)
    active = try row.get(Keys.active)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.position, position)
    try row.set(Keys.photoUrl, photoUrl)
    try row.set(Keys.info, info)
    try row.set(Keys.url, url)
    try row.set(Keys.active, active)
    return row
  }
  // sourcery:end
}

extension Creator: JSONRepresentable {

  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.userId, userId)
    try json.set(Keys.position, position)
    try json.set(Keys.photoUrl, photoURL())
    try json.set(Keys.info, info)
    try json.set(Keys.url, url)
    try json.set(Keys.active, active)
    return json
  }

}

extension Creator {

  func user() throws -> User? {
    return try parent(id: userId).get()
  }

  func photoURL() -> String? {
    guard
      let config = try? Config(),
      let domain = config[Constants.Config.app, Constants.Config.domain]?.string,
      let userId = self.id?.string
      else {
        return nil
    }
    let photosFolder = Constants.Path.creatorsPhotos
    return "\(domain)/\(photosFolder)/\(userId)/\(self.photoUrl)"
  }

}
