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
class UserPhotoTest: TestCase {

  let photoPath = "user_photos/1/"
  let testResouces = "Tests/Resources/"
  var storedDir = ""
  let fileManager = Foundation.FileManager()
  var clientToken = ""
  var headers: [HeaderKey: String] = [:]
  var domain = ""

  override func setUp() {
    super.setUp()
    do {
      try drop.truncateTables()
      storedDir = drop.config.publicDir + photoPath
      clientToken = drop.config["app", "client-token"]?.string ?? ""
      domain = drop.config["app", "domain"]!.string!
      headers = [
        "client-token": clientToken,
        HeaderKey.contentType: TestConstants.Header.Value.multipartFormData
      ]
    } catch {
      XCTFail("Droplet set raise exception: \(error.localizedDescription)")
      return
    }
  }

  func testThatUserPhotoisUpdatedUsingFormDataContent() throws {

    let user = try! storeUser()
    user.photo = nil
    try! user.save()

    let fileName = "robot-1469114466kSY.jpg"
    let filePath = drop.config.workDir + testResouces + fileName
    let storedFilePath = storedDir + fileName

    let expectedPhoto = "\(domain)/\(photoPath + fileName)"

    try! fileManager.removeAllFiles(atPath: storedDir)

    let filePhoto = try! Vapor.FileManager.readBytesFromFile(filePath)
    let partPhoto = Part(headers: [:], body: filePhoto)
    let photo = Field(name: "photo", filename: fileName, part: partPhoto)

    headers[HeaderKey.authorization] = "Bearer \(user.token!)"

    let request = Request(method: .patch, uri: "http://0.0.0.0:8080/api/user/1", headers: headers)
    request.formData = ["photo": photo]
    
    let response = try drop.respond(to: request)
    response.assertStatus(is: .ok)

    guard
      let updatedUser = response.json,
      let newPhoto = updatedUser["photo_url"]?.string
    else {
      XCTFail("Can't get updatedUser")
      return
    }

    XCTAssertEqual(expectedPhoto, newPhoto, "got: '\(newPhoto)', expected: '\(expectedPhoto)'")
    XCTAssertTrue( try! CryptoHasher.compareFiles(filePath1: filePath, filePath2: storedFilePath))
  }

  func testThatUsingPhotoWithBase64EncodedStringContent() throws {

    let fileName = "robot-1469114466kSY.jpg"
    let filePath = drop.config.workDir + testResouces + fileName

    let response = try! postUserPhotoFromFileByBase64EncodedString(from: fileName).assertStatus(is: .ok)

    guard
      let updatedUser = response.json,
      let newPhotoURL = updatedUser["photo_url"]?.string,
      let photoFileName = URL(string: newPhotoURL)?.lastPathComponent
    else {
        XCTFail("Can't get photo path")
        return
    }

    let storedFilePath = storedDir + photoFileName
    XCTAssertTrue( try! CryptoHasher.compareFiles(filePath1: filePath, filePath2: storedFilePath))

  }

  func testThatUserPhotoIsUpdatedUsingPhotoAtURL() throws {

    let user = try! storeUser()
    user.photo = nil
    try! user.save()

    let url = "http://mabi.vspu.ru/files/2017/06/robot.jpg"
    let fileName = "robot.jpg"
    let filePath = drop.config.workDir + testResouces + fileName
    try! fileManager.removeAllFiles(atPath: storedDir)
    
    let body = try! Body(node: [
      "photoURL": url,
      "token": user.token!
    ])

    let response = try! postUserPhoto(body:  body).assertStatus(is: .ok)

    guard
      let updatedUser = response.json,
      let newPhotoURL = updatedUser["photo_url"]?.string,
      let photoFileName = URL(string: newPhotoURL)?.lastPathComponent
      else {
        XCTFail("Can't get photo path")
        return
    }

    let storedFilePath = storedDir + photoFileName
    XCTAssertTrue( try! CryptoHasher.compareFiles(filePath1: filePath, filePath2: storedFilePath))

  }
//  Need change the drop call to drop.foreground
//  func testThatUserPhotoIsDownloadedFromServer() throws {
//
//    let fileName = "robot-1469114466kSY.jpg"
//    let filePath = drop.config.workDir + testResouces + fileName
//    let storedDir = drop.config.publicDir + photoPath
//
//    let response = try! postUserPhotoFromFileByBase64EncodedString(from: fileName).assertStatus(is: .ok)
//
//    guard
//      let updatedUser = response.json,
//      let newPhotoURL = updatedUser["photo"]?.string,
//      let photoFileName = URL(string: newPhotoURL)?.lastPathComponent
//      else {
//        XCTFail("Can't get photo path")
//        return
//    }
//
//    let storedFilePath = storedDir + photoFileName
//    XCTAssertTrue( try! CryptoHasher.compareFiles(filePath1: filePath, filePath2: storedFilePath))
//
//    print("\n\n\(newPhotoURL)\n\n")
//
//    //let request = Request(method: .get, uri: newPhotoURL, headers: headers)
//    let responseServer = try! drop.request(.get, newPhotoURL, headers )
//
//    responseServer.assertStatus(is: .ok)
//
//    guard let photoBytes = responseServer.body.bytes else {
//      XCTFail("Can't get photo from url: '\(newPhotoURL)'")
//      return
//    }
//
//    XCTAssertTrue( try! CryptoHasher.compareFileAndBytes(filePath: filePath, bytes: photoBytes))
//
//  }

}

extension UserPhotoTest {

  @discardableResult
  func storeUser() throws -> User {
    let user = User()
    try! user.save()
    user.createSession()
    return user
  }

  func postUserPhoto(body: JSON) throws -> Response {
    return try! drop
      .userAuthorizedTestResponse(
        to: .patch,
        at: "api/user/1",
        body: body,
        bearer: body["token"]?.string)
  }

  func postUserPhotoFromFileByBase64EncodedString(from fileName: String) throws -> Response {

    let user = try! storeUser()
    user.photo = nil
    try! user.save()

    let filePath = drop.config.workDir + testResouces + fileName
    let fileManager = Foundation.FileManager()
    let storedDir = drop.config.publicDir + photoPath

    try! fileManager.removeAllFiles(atPath: storedDir)

    let filePhoto = try! Vapor.FileManager.readBytesFromFile(filePath)
    let data = Data(filePhoto)
    let stringPhoto = data.base64EncodedString()

    let body = try! Body(node: [
      "photo": stringPhoto,
      "token": user.token!
    ])
    return try! postUserPhoto(body:  body)

  }

}
