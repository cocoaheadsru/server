import Vapor
import FluentProvider

final class Speech: Model {
    
    let storage = Storage()
    
    var eventId: Node
    var title: String
    var description: String
    var speakerId: Node
    var photoUrl: String
    
    struct Keys {
        static let id = "id"
        static let eventId = "event_id"
        static let title = "title"
        static let description = "description"
        static let speakerId = "speaker_id"
        static let photoUrl = "photo_url"
    }
    
    init(eventId: Node, title: String, description: String, speakerId: Node, photoUrl: String) {
        self.eventId = eventId
        self.title = title
        self.description = description
        self.speakerId = speakerId
        self.photoUrl = photoUrl
    }
    
    // MARK: Fluent Serialization
    
    init(row: Row) throws {
        eventId = try row.get(Speech.Keys.eventId)
        title = try row.get(Speech.Keys.title)
        description = try row.get(Speech.Keys.description)
        speakerId = try row.get(Speech.Keys.speakerId)
        photoUrl = try row.get(Speech.Keys.photoUrl)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Speech.Keys.eventId, eventId)
        try row.set(Speech.Keys.title, title)
        try row.set(Speech.Keys.description, description)
        try row.set(Speech.Keys.speakerId, speakerId)
        try row.set(Speech.Keys.photoUrl, photoUrl)
        return row
    }
}

extension Speech {
    
    func event() throws -> Event? {
        return try children().first()
    }

    func speaker() throws -> Speaker? {
        return try children().first()
    }
}

// MARK: Fluent Preparation

extension Speech: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.foreignKey(Speech.Keys.eventId, references: Event.Keys.id, on: Event.self, named: "event")
            builder.string(Speech.Keys.title)
            builder.string(Speech.Keys.description)
            builder.foreignKey(Speech.Keys.speakerId, references: Speaker.Keys.id, on: Speaker.self, named: "speaker")
            builder.string(Speech.Keys.photoUrl)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

extension Speech: JSONRepresentable {
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Speech.Keys.id, id)
        try json.set(Speech.Keys.eventId, eventId)
        try json.set(Speech.Keys.title, title)
        try json.set(Speech.Keys.description, description)
        try json.set(Speech.Keys.speakerId, speakerId)
        try json.set(Speech.Keys.photoUrl, photoUrl)
        return json
    }
}

// MARK: HTTP

extension Speech: ResponseRepresentable { }

