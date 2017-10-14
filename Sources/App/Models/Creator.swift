import Vapor
import FluentProvider

final class Creator: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    // MARK: Fluent Serialization
    
    /// Initializes the Creator from the
    /// database row
    init(row: Row) throws {
        //
    }
    
    // Serializes the Creator to the database
    func makeRow() throws -> Row {
        var row = Row()
        return row
    }
}
