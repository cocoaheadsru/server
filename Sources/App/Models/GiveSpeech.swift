import Vapor
import FluentProvider

final class GiveSpeech: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    // MARK: Fluent Serialization
    
    /// Initializes the GiveSpeech from the
    /// database row
    init(row: Row) throws {
        //
    }
    
    // Serializes the GiveSpeech to the database
    func makeRow() throws -> Row {
        var row = Row()
        return row
    }
}
