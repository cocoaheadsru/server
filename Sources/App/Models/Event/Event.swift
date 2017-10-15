import Vapor
import FluentProvider

final class Event: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    // MARK: Fluent Serialization
    
    /// Initializes the Event from the
    /// database row
    init(row: Row) throws {
        //
    }
    
    // Serializes the Event to the database
    func makeRow() throws -> Row {
        var row = Row()
        return row
    }
}
