import XCTest
import Testing
import HTTP
import Core
import Foundation
import Multipart
import FormData
import Crypto

@testable import Vapor
@testable import App

// swiftlint:disable superfluous_disable_command
// swiftlint:disable force_try
class UserPhotoUpdateTest: TestCase {

  var drop: Droplet!

  override func setUp() {
    super.setUp()
    do {
      drop = try Droplet.testable()
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatUserPhotoIsUpdatedByFormDataSend() throws {

    let user = User()
    user.photo = nil
    try! user.save()

    let fileName = "robot-1469114466kSY.jpg"
    let photoPath = "user_photos/1/"
    let filePath = drop.config.workDir + "Tests/Resources/" + fileName
    let fileManager = Foundation.FileManager()
    let storedDir = drop.config.publicDir + photoPath
    let storedFilePath = storedDir + fileName
    let domain =  drop.config["server", "domain"]!.string
    let expectedPhoto = "\(domain ?? "")/\(photoPath + fileName)"
    let token = drop.config["server", "client-token"]?.string

    try! fileManager.removeAllFiles(atPath: storedDir)

    let headers: [HeaderKey: String] = [
      "client-token": token!,
      TestConstants.Header.Key.contentType: TestConstants.Header.Value.multipartFormData
    ]

    let filePhoto = try! Vapor.FileManager.readBytesFromFile(filePath)
    let partPhoto = Part(headers: [:], body: filePhoto)
    let photo = Field(name: "photo", filename: fileName, part: partPhoto)

    let request = Request(method: .patch, uri: "http://0.0.0.0:8080/user/1", headers: headers)
    request.formData = ["photo": photo]
    
    let response = try drop.respond(to: request)
    response.assertStatus(is: .ok)

    guard
      let updatedUser = response.json,
      let newPhoto = updatedUser["photo"]?.string
    else {
      XCTFail("Can't get updatedUser")
      return
    }

    XCTAssertEqual(expectedPhoto, newPhoto, "got: '\(newPhoto)', expected: '\(expectedPhoto)'")
    XCTAssertTrue( try! CryptoHasher.compareFiles(filePath1: filePath, filePath2: storedFilePath))
  }

  func testThatUserPhotoIsUpdatedByPhotoSendAsBase64EncodedString() throws {

    let user = User()
    user.photo = nil
    try! user.save()

    let fileName = "robot-1469114466kSY.jpg"
    let photoPath = "user_photos/1/"
    let filePath = drop.config.workDir + "Tests/Resources/" + fileName
    let fileManager = Foundation.FileManager()
    let storedDir = drop.config.publicDir + photoPath

    try! fileManager.removeAllFiles(atPath: storedDir)

    let filePhoto = try! Vapor.FileManager.readBytesFromFile(filePath)
    let data = Data(filePhoto)
    let stringPhoto = data.base64EncodedString()

    let body = try! Body(node: ["photo": stringPhoto])

    let response = try! drop
      .clientAuthorizedTestResponse(
        to: .patch,
        at: "user/1",
        body: body)
      .assertStatus(is: .ok)

    guard
      let updatedUser = response.json,
      let newPhotoURL = updatedUser["photo"]?.string,
      let photoFileName = URL(string: newPhotoURL)?.lastPathComponent
    else {
        XCTFail("Can't get photo path")
        return
    }

    let storedFilePath = storedDir + photoFileName
    XCTAssertTrue( try! CryptoHasher.compareFiles(filePath1: filePath, filePath2: storedFilePath))

  }

  func testThatUserPhotoIsUpdatedByPhotoSendAsURL() throws {

    let user = User()
    user.photo = nil
    try! user.save()

    let url = "http://mabi.vspu.ru/files/2017/06/robot.jpg"
    let fileName = "robot.jpg"
    let photoPath = "user_photos/1/"
    let filePath = drop.config.workDir + "Tests/Resources/" + fileName
    let fileManager = Foundation.FileManager()
    let storedDir = drop.config.publicDir + photoPath

    try! fileManager.removeAllFiles(atPath: storedDir)
    
    let body = try! Body(node: ["photoURL": url])

    let response = try! drop
      .clientAuthorizedTestResponse(
        to: .patch,
        at: "user/1",
        body: body)
      .assertStatus(is: .ok)

    guard
      let updatedUser = response.json,
      let newPhotoURL = updatedUser["photo"]?.string,
      let photoFileName = URL(string: newPhotoURL)?.lastPathComponent
      else {
        XCTFail("Can't get photo path")
        return
    }

    let storedFilePath = storedDir + photoFileName
    XCTAssertTrue( try! CryptoHasher.compareFiles(filePath1: filePath, filePath2: storedFilePath))

  }
}
