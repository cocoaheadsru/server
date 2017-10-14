import Vapor
import FluentProvider

final class City: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    var cityName: String
    
    /// The column names for `id` and `cityName` in the database
    struct Keys {
        static let id = "id"
        static let cityName = "city_name"
    }
    
    /// Creates a new City
    init(cityName: String) {
        self.cityName = cityName
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the City from the
    /// database row
    init(row: Row) throws {
        cityName = try row.get(City.Keys.cityName)
    }
    
    // Serializes the City to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(City.Keys.cityName, cityName)
        return row
    }
}

// MARK: Fluent Preparation

extension City: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Cities
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(City.Keys.cityName)
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
extension City: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(
            cityName: try json.get(City.Keys.cityName)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(City.Keys.id, id)
        try json.set(City.Keys.cityName, cityName)
        return json
    }
}

// MARK: HTTP

// This allows City models to be returned
// directly in route closures
extension City: ResponseRepresentable { }
