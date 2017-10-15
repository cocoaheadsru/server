import Vapor
import FluentProvider

final class Speaker: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    // MARK: Fluent Serialization
    
    /// Initializes the Speaker from the
    /// database row
    init(row: Row) throws {
        //
    }
    
    // Serializes the Speaker to the database
    func makeRow() throws -> Row {
        var row = Row()
        return row
    }
}
