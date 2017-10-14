import Vapor
import FluentProvider

final class Content: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    // MARK: Fluent Serialization
    
    /// Initializes the Content from the
    /// database row
    init(row: Row) throws {
        //
    }
    
    // Serializes the Content to the database
    func makeRow() throws -> Row {
        var row = Row()
        return row
    }
}
