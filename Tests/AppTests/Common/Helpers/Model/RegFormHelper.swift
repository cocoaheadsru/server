import Vapor
@testable import App

final class RegFormHelper {
  
  static func cleanRegFormTable() throws {
    try RegForm.makeQuery().delete()
  }
  
  static func cleanAllTablesRegFormDepends() throws {
    try Event.makeQuery().delete()
    try Place.makeQuery().delete()
    try City.makeQuery().delete()
  }
  
  static func cleanAllTablesRegFormDepended() throws {
    
    
  }
  
  
  
  
  
  
}
