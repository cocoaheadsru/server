import Vapor
import FluentProvider

final class Speaker: Model {
    
    let storage = Storage()
    
    var userId: Node
    var eventId: Node
    
    struct Keys {
        static let id = "id"
        static let userId = "user_id"
        static let eventId = "event_id"
    }
    
    init(userId: Node, eventId: Node) {
        self.userId = userId
        self.eventId = eventId
    }
    
    // MARK: Fluent Serialization
    
    init(row: Row) throws {
        userId = try row.get(Speaker.Keys.userId)
        eventId = try row.get(Speaker.Keys.eventId)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Speaker.Keys.userId, userId)
        try row.set(Speaker.Keys.eventId, eventId)
        return row
    }
}

extension Speech {
//    Uncomment when User model is created
//    func user() throws -> User? {
//        return try children().first()
//    }
    
    func event() throws -> Speech? {
        return try children().first()
    }
}

// MARK: Fluent Preparation

extension Speaker: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            // Uncomment when User model is created
            //builder.foreignKey(Speaker.Keys.userId, references: User.Keys.id, on: User.self, named: "user")
            builder.foreignKey(Speaker.Keys.eventId, references: Event.Keys.id, on: Event.self, named: "event")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

extension Speaker: JSONRepresentable {
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Speaker.Keys.id, id)
        try json.set(Speaker.Keys.userId, userId)
        try json.set(Speaker.Keys.eventId, eventId)
        return json
    }
}

// MARK: HTTP

extension Speaker: ResponseRepresentable { }
