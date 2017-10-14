import Vapor
import FluentProvider

final class Place: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    // MARK: Fluent Serialization
    
    /// Initializes the Place from the
    /// database row
    init(row: Row) throws {
        //
    }
    
    // Serializes the Place to the database
    func makeRow() throws -> Row {
        var row = Row()
        return row
    }
}
