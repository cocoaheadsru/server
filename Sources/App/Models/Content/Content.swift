import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Content: Model {
    
  let storage = Storage()
  
  // sourcery: relation = parent, relatedModel = Speech
  var speechId: Identifier
  // sourcery: enum, video, slide
  var type: ContentType
  var title: String
  var description: String
  var link: String
  
  init(speechId: Identifier,
       title: String,
       description: String,
       link: String,
       type: ContentType) {
    self.speechId = speechId
    self.title = title
    self.description = description
    self.link = link
    self.type = type
  }
  
  // sourcery:inline:auto:Content.AutoModelGeneratable
  init(row: Row) throws {
    speechId = try row.get(Keys.speechId)
    type = ContentType(try row.get(Keys.type))
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
    link = try row.get(Keys.link)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.speechId, speechId)
    try row.set(Keys.type, type.string)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    try row.set(Keys.link, link)
    return row
  }
  // sourcery:end
}

extension Content {
  
  func speech() throws -> Speech? {
    return try parent(id: speechId).get()
  }
}
