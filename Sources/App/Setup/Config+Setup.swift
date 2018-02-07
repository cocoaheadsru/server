import FluentProvider
import MySQLProvider

extension Config {
  public func setup() throws {
    // allow fuzzy conversions for these types
    // (add your own types here)
    Node.fuzzy = [Row.self, JSON.self, Node.self]
    try setupProviders()
    try setupPreparations()
    try setupMiddleware()
  }
  
  /// Configure providers
  private func setupProviders() throws {
    try addProvider(FluentProvider.Provider.self)
    try addProvider(MySQLProvider.Provider.self)
  }
  
  /// Add all models that should have their
  /// schemas prepared before the app boots
  private func setupPreparations() throws {
  
    let entities: [Preparation.Type] = [
      Approval.self,
      Heartbeat.self,
      User.self,
      Client.self,
      Session.self,
      City.self,
      Place.self,
      Event.self,
      RegForm.self,
      EventReg.self,
      Rule.self,
      RegField.self,
      RegFieldAnswer.self,
      EventRegAnswer.self,
      Speech.self,
      Speaker.self,
      Content.self,
      Creator.self,
      GiveSpeech.self,
      Social.self,
      SocialAccount.self,
      Pivot<RegField, Rule>.self
    ]
    
    entities
      .forEach {
        preparations.append($0)
      }
    
  }
  
  // Configure Middleware
  private func setupMiddleware() throws {
    self.addConfigurable(middleware: ClientMiddleware.init, name: Constants.Middleware.client)
  }

}
