import Vapor
import FluentProvider

final class Event: Model {
    
    let storage = Storage()
    
    var title: String
    var description: String
    var photoUrl: String
    var placeId: Node
    var isRegistrationOpen: Bool = true
    var startDate: Int
    var endDate: Int
    var isHidden: Bool = false
    
    struct Keys {
        static let id = "id"
        static let title = "title"
        static let description = "description"
        static let photoUrl = "photo_url"
        static let placeId = "place_id"
        static let isRegistrationOpen = "is_registration_open"
        static let startDate = "start_date"
        static let endDate = "end_date"
        static let isHidden = "hide"
    }
    
    init(title: String, description: String, photoUrl: String, placeId: Node, isRegistrationOpen: Bool = true, startDate: Int, endDate: Int, isHidden: Bool = false) {
        self.title = title
        self.description = description
        self.photoUrl = photoUrl
        self.placeId = placeId
        self.isRegistrationOpen = isRegistrationOpen
        self.startDate = startDate
        self.endDate = endDate
        self.isHidden = isHidden
    }
    
    // MARK: Fluent Serialization
    
    init(row: Row) throws {
        title = try row.get(Event.Keys.title)
        description = try row.get(Event.Keys.description)
        photoUrl = try row.get(Event.Keys.photoUrl)
        placeId = try row.get(Event.Keys.placeId)
        isRegistrationOpen = try row.get(Event.Keys.isRegistrationOpen)
        startDate = try row.get(Event.Keys.startDate)
        endDate = try row.get(Event.Keys.endDate)
        isHidden = try row.get(Event.Keys.isHidden)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Event.Keys.title, title)
        try row.set(Event.Keys.description, description)
        try row.set(Event.Keys.photoUrl, photoUrl)
        try row.set(Event.Keys.placeId, placeId)
        try row.set(Event.Keys.isRegistrationOpen, isRegistrationOpen)
        try row.set(Event.Keys.startDate, startDate)
        try row.set(Event.Keys.endDate, endDate)
        try row.set(Event.Keys.isHidden, isHidden)
        return row
    }
}

// MARK: Fluent Preparation

extension Event: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Event.Keys.title)
            builder.string(Event.Keys.description)
            builder.string(Event.Keys.photoUrl)
            builder.foreignKey(Event.Keys.placeId, references: Place.Keys.id, on: Place.self, named: "place")
            builder.bool(Event.Keys.isRegistrationOpen)
            builder.int(Event.Keys.startDate)
            builder.int(Event.Keys.endDate)
            builder.bool(Event.Keys.isHidden)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

extension Event: JSONRepresentable {
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Event.Keys.id, id)
        try json.set(Event.Keys.title, title)
        try json.set(Event.Keys.description, description)
        try json.set(Event.Keys.photoUrl, photoUrl)
        try json.set(Event.Keys.placeId, placeId)
        try json.set(Event.Keys.isRegistrationOpen, isRegistrationOpen)
        try json.set(Event.Keys.startDate, startDate)
        try json.set(Event.Keys.endDate, endDate)
        try json.set(Event.Keys.isHidden, isHidden)
        return json
    }
}

// MARK: HTTP

extension Event: ResponseRepresentable { }
