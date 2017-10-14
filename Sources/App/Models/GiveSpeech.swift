import Vapor
import FluentProvider

final class GiveSpeech: Model {
    let storage = Storage()

    // MARK: Properties and database keys
    
    var title: String
    var description: String
    var userId: Node
    
    /// The column names for `id`, `title`, `description`,
    /// and 'user_id' in the database
    struct Keys {
        static let id = "id"
        static let title = "title"
        static let description = "description"
        static let userId = "user_id"
    }
    
    /// Creates a new GiveSpeech
    init(title: String, description: String, userId: Node) {
        self.title = title
        self.description = description
        self.userId = userId
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the GiveSpeech from the
    /// database row
    init(row: Row) throws {
        title = try row.get(GiveSpeech.Keys.title)
        description = try row.get(GiveSpeech.Keys.description)
        userId = try row.get(GiveSpeech.Keys.userId)
    }
    
    // Serializes the GiveSpeech to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(GiveSpeech.Keys.title, title)
        try row.set(GiveSpeech.Keys.description, description)
        try row.set(GiveSpeech.Keys.userId, userId)
        return row
    }
}

// MARK: Fluent Preparation

extension GiveSpeech: Preparation {
    /// Prepares a table/collection in the database
    /// for storing GiveSpeechs
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(GiveSpeech.Keys.title)
            builder.string(GiveSpeech.Keys.description)
            // Uncomment when User model is created
            //builder.foreignKey(GiveSpeech.Keys.userId, references: User.Keys.id, on: User.self, named: "user")
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON
// How the model converts from / to JSON.
//
extension GiveSpeech: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(
            title: try json.get(GiveSpeech.Keys.title),
            description: try json.get(GiveSpeech.Keys.description),
            userId: try json.get(GiveSpeech.Keys.userId)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(GiveSpeech.Keys.id, id)
        try json.set(GiveSpeech.Keys.title, title)
        try json.set(GiveSpeech.Keys.description, description)
        try json.set(GiveSpeech.Keys.userId, userId)
        return json
    }
}

// MARK: HTTP

// This allows GiveSpeech models to be returned
// directly in route closures
extension GiveSpeech: ResponseRepresentable { }
