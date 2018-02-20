import Vapor

final class UserSample {

  private let photoController: PhotoConroller
  private let drop: Droplet
  private let randomPhotoURL = "https://picsum.photos/200/300?image="

  init(drop: Droplet) {
    self.drop = drop
    photoController = PhotoConroller(drop: self.drop)
  }

  func createSample() throws {

    func createUser(index: Int) throws {

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
      user.photo = try photoController.downloadAndSavePhoto(for: user, by: photoURL)
      try user.save()

    }

    for i in 1...Int.random(min: 2, max: 5) {
      try createUser(index: i)
    }

  }

}
