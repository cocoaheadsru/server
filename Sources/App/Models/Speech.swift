import Vapor
import FluentProvider

final class Speech: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    // MARK: Fluent Serialization
    
    /// Initializes the Speech from the
    /// database row
    init(row: Row) throws {
        //
    }
    
    // Serializes the Speech to the database
    func makeRow() throws -> Row {
        var row = Row()
        return row
    }
}
