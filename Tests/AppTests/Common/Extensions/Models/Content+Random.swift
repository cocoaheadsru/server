import Vapor
@testable import App

extension App.Content {
  
  convenience init(_ randomlyInitialized: Bool = true, speechId: Identifier) {
    if randomlyInitialized {
      self.init(
        speechId: speechId,
        title: String.randomValue,
        description: String.randomValue,
        link: String.randomValue,
        type: Bool.randomValue ? .video : .slide)
    } else {
      self.init(
        speechId: speechId,
        title: "",
        description: "",
        link: "",
        type: .video )
    }
  }
  
}
