import Vapor
import FluentProvider

final class Content: Model {
    
    let storage = Storage()
    
    var speechId: Node
    var title: String
    var description: String
    var link: String
    var type: ContentType
    
    enum ContentType {
        case video
        case slide
        
        var string: String {
            return String(describing: self)
        }
        
        init(_ string: String) {
            switch string {
            case "video": self = .video
            case "slide": self = .slide
            default: self = .video
            }
        }
    }
    
    struct Keys {
        static let id = "id"
        static let speechId = "speech_id"
        static let title = "title"
        static let description = "description"
        static let link = "link"
        static let type = "type"
    }
    
    init(speechId: Node, title: String, description: String, link: String, type: ContentType) {
        self.speechId = speechId
        self.title = title
        self.description = description
        self.link = link
        self.type = type
    }
    
    // MARK: Fluent Serialization
    
    init(row: Row) throws {
        speechId = try row.get(Content.Keys.speechId)
        title = try row.get(Content.Keys.title)
        description = try row.get(Content.Keys.description)
        link = try row.get(Content.Keys.link)
        let typeString: String = try row.get(Content.Keys.type)
        type = ContentType(typeString)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Content.Keys.speechId, speechId)
        try row.set(Content.Keys.title, title)
        try row.set(Content.Keys.description, description)
        try row.set(Content.Keys.link, link)
        try row.set(Content.Keys.type, type.string)
        return row
    }
}

// MARK: Fluent Preparation

extension Content: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.foreignKey(Content.Keys.speechId, references: Speech.Keys.id, on: Speech.self, named: "speech")
            builder.string(Content.Keys.title)
            builder.string(Content.Keys.description)
            builder.string(Content.Keys.link)
            builder.string(Content.Keys.type)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

extension Content: JSONRepresentable {
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Content.Keys.id, id)
        try json.set(Content.Keys.speechId, speechId)
        try json.set(Content.Keys.title, title)
        try json.set(Content.Keys.description, description)
        try json.set(Content.Keys.link, link)
        try json.set(Content.Keys.type, type.string)
        return json
    }
}

// MARK: HTTP

extension Content: ResponseRepresentable { }
