import Vapor

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
extension Samples {

  func createCreatorSample() throws {

    func createCreator(user: User) throws {

      let creator = Creator(
        userId: user.id!,
        position: user.id!.int!,
        info: String.randomValue,
        url: String.randomURL,
        active: Bool.randomValue
      )

      try creator.save()
    }

    try createUserSample(count: 10).forEach { user in
      try createCreator(user: user)
    }
  }

}
