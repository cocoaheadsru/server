import Vapor

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
extension Samples {

  @discardableResult
  func createUserSample(count: Int = 5) throws -> [User] {

    let photoController = PhotoController(drop: drop)
    let randomPhotoURL = "https://picsum.photos/200/300?image="

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
      try! user.save()
      user.createSession()
      user.token = "test\(index)"
      user.photo = try! photoController.downloadAndSavePhoto(for: user, with: photoURL)
      try! user.save()
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
