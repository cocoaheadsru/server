import Vapor

final class UserSample {

  private let photoController: PhotoController
  private let drop: Droplet
  private let randomPhotoURL = "https://picsum.photos/200/300?image="

  init(drop: Droplet) {
    self.drop = drop
    photoController = PhotoController(drop: self.drop)
  }
  @discardableResult
  func createSample(count: Int = 5) throws -> [User] {

    func createUser(index: Int) throws -> User {

      let user = User(
        name: "TestNameUser\(index)" ,
        lastname: "TestLastNameUser\(index)",
        company: "TestCompany\(index)",
        position: "TestPosition\(index)",
        photo: "",
        email: String.randomEmail,
        phone: String.randomPhone
      )

      let photoURL = "\(randomPhotoURL)\(Int.random(min: 0, max: 200))"
      try user.save()
      user.token = "test\(index)"
      user.photo = try photoController.downloadAndSavePhoto(for: user, with: photoURL)
      try user.save()
      return user
    }

    var users: [User] = []
    for i in 1...Int.random(min: 2, max: count) {
     let user = try createUser(index: i)
     users.append(user)
    }
    return users
  }

}
