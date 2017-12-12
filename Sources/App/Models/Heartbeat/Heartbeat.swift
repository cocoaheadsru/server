import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation
final class Heartbeat: Model {
  let storage = Storage()
  
  var beat: Int
  
  init(beat: Int) {
    self.beat = beat
  }
  

  // sourcery:inline:auto:Heartbeat.AutoModelGeneratable
  init(row: Row) throws {
    beat = try row.get(Keys.beat)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.beat, beat)
    return row
  }
  // sourcery:end
}
