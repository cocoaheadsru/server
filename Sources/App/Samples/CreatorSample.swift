import Vapor

final class CreatorSample {

  private let photoController: PhotoController
  private let drop: Droplet
  private let userSample: UserSample

  init(drop: Droplet) {
    self.drop = drop
    photoController = PhotoController(drop: self.drop)
    userSample = UserSample(drop: drop)
  }

  func createSample() throws {

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

    try userSample.createSample(count: 10).forEach { (user) in
      try createCreator(user: user)
    }

  }

}
