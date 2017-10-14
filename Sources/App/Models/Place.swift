import Vapor
import FluentProvider

final class Place: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    var id: Node?
    var title: String
    var address: String
    var description: String
    var latitude: Double
    var longitude: Double
    var cityId: Node
    
    /// The column names for `id`, `title`, `address`, `description`,
    /// `latitude`, `longitude` and 'city_id' in the database
    struct Keys {
        static let id = "place_id"
        static let title = "title"
        static let address = "address"
        static let description = "description"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let cityId = "city_id"
    }
    
    /// Creates a new Place
    init(title: String, address: String, description: String, latitude: Double, longitude: Double, cityId: Node) {
        self.title = title
        self.address = address
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.cityId = cityId
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the Place from the
    /// database row
    init(row: Row) throws {
        title = try row.get(Place.Keys.title)
        address = try row.get(Place.Keys.address)
        description = try row.get(Place.Keys.description)
        latitude = try row.get(Place.Keys.latitude)
        longitude = try row.get(Place.Keys.longitude)
        cityId = try row.get(Place.Keys.cityId)
    }
    
    // Serializes the Place to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Place.Keys.title, title)
        try row.set(Place.Keys.address, address)
        try row.set(Place.Keys.description, description)
        try row.set(Place.Keys.latitude, latitude)
        try row.set(Place.Keys.longitude, longitude)
        try row.set(Place.Keys.cityId, cityId)
        return row
    }
}

// MARK: Fluent Preparation

extension Place: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Places
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Place.Keys.title)
            builder.string(Place.Keys.address)
            builder.string(Place.Keys.description)
            builder.double(Place.Keys.latitude)
            builder.double(Place.Keys.longitude)
            builder.foreignKey(Place.Keys.cityId, references: City.Keys.id, on: City.self, named: "city")
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
extension Place: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(
            title: try json.get(Place.Keys.title),
            address: try json.get(Place.Keys.address),
            description: try json.get(Place.Keys.description),
            latitude: try json.get(Place.Keys.latitude),
            longitude: try json.get(Place.Keys.longitude),
            cityId: try json.get(Place.Keys.cityId)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Place.Keys.id, id)
        try json.set(Place.Keys.title, title)
        try json.set(Place.Keys.address, address)
        try json.set(Place.Keys.description, description)
        try json.set(Place.Keys.latitude, latitude)
        try json.set(Place.Keys.longitude, longitude)
        try json.set(Place.Keys.cityId, cityId)
        return json
    }
}

// MARK: HTTP

// This allows Place models to be returned
// directly in route closures
extension Place: ResponseRepresentable { }
