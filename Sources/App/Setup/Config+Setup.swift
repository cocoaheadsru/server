import FluentProvider
import MySQLProvider

extension Config {
  public func setup() throws {
    // allow fuzzy conversions for these types
    // (add your own types here)
    Node.fuzzy = [Row.self, JSON.self, Node.self]
    
    try setupProviders()
    try setupPreparations()
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
      User.self,
      Client.self,
      Session.self,
      Migration.self,
      Event.self,
      Place.self,
      City.self,
      EventReg.self,
      EventRegField.self,
      EventRegAnswer.self,
      RegForm.self,
      RegField.self,
      RegFieldRule.self,
      RegFieldAnswer.self,
      Speech.self,
      Speaker.self,
      Content.self,
      Creator.self,
      GiveSpeech.self,
      Social.self,
      SocialAccount.self
    ]
    
    entities
      .forEach {
        preparations.append($0)
      }
  }
}
