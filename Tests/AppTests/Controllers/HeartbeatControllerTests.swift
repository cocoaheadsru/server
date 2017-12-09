//
//  HeartbeatControllerTests.swift
//  AppTests
//
//  Created by di on 30.11.2017.
//

import XCTest
import Testing
import HTTP
import Sockets
import Fluent
@testable import Vapor
@testable import App

class HeartbeatControllerTests: TestCase {
  
  let drop = try! Droplet.testable()
  let controller = HeartbeatController()
  
  func testThatPostSetBeatAnyValue() throws {
    // arrange
    let beat = 33
    // act
    guard let res = try setBeat(to: beat) as? Response else {
      XCTFail()
      return
    }
    // assert
    try res.assertJSON("beat", equals: beat)
  }
  
  func testThatRowCountAfterStoreAlwaysBeEqualOne() throws {
    // arrange
    let beat1 = 56
    let beat2 = 33
    let beat3 = 45
    // act
    _ = try setBeat(to: beat1)
    let count1 = try Heartbeat.count()
    //assert
    XCTAssert(count1 == 1)
    // act
    _ = try setBeat(to: beat2)
    let count2 = try Heartbeat.count()
    // assert
    XCTAssert(count2 == 1)
    // act
    _ = try setBeat(to: beat3)
    let count3 = try Heartbeat.count()
    // assert
    XCTAssert(count3 == 1)
  }
  
  func testThatShowGet204NoContentForEmptyBeatTable() throws {
    // arange
    try Heartbeat.makeQuery().delete()
    let req = Request.makeTest(method: .get)
    // act
    let res = try controller.index(req: req).makeResponse()
    // assert
    res.assertStatus(is: .noContent)
  }
  
  func testThatShowGetCurrentValueIfBeatTableIsNotEmpty() throws {
    // arange
    try Heartbeat.makeQuery().delete()
    let beat = 45
    _ = try setBeat(to: beat)
    let req = Request.makeTest(method: .get)
    // act
    let res = try controller.index(req: req).makeResponse()
    // assert
    try res.assertJSON("beat", equals: beat)
  }
  
  func testThatRoutePostMethodShouldSetAnyIntValue() throws {
    // arrange
    let beat = 488
    let heartbeat = Heartbeat(beat: beat)
    let json = try heartbeat.makeJSON()
    let reqBody = try Body(json)
    let req = Request(method: .post, uri: "/heartbeat", headers: ["Content-Type": "application/json"], body: reqBody)
    
    // act & assert
    try drop
      .testResponse(to: req)
      .assertStatus(is: .ok)
      .assertJSON("beat", equals: beat)
  }
  
  func testThatRouteGet204NoContectForEmptyBeatTable() throws {
    // arange
    try Heartbeat.makeQuery().delete()
    // act & assert
    try drop
      .testResponse(to: .get, at: "heartbeat")
      .assertStatus(is: .noContent)
  }
  
  func testThatRouteGetCurrentValueIfBeatTableIsNotEmpty() throws {
    // arange
    try Heartbeat.makeQuery().delete()
    let beat = 893
    _ = try setBeat(to: beat)
    // act & assert
    try drop
      .testResponse(to: .get, at: "heartbeat")
      .assertStatus(is: .ok)
      .assertJSON("beat", equals: beat)
  }
  
  func testThatRouteHearbeatScenarioIsCorrect() throws {
    // arrange
    let beat = 1
    let heartbeat = Heartbeat(beat: beat)
    let json = try heartbeat.makeJSON()
    let reqBody = try Body(json)
    let req = Request(method: .post, uri: "/heartbeat", headers: ["Content-Type": "application/json"], body: reqBody)
    
    // act & assert
    try drop
      .testResponse(to: req)
      .assertStatus(is: .ok)
      .assertJSON("beat", equals: beat)
    
    try drop
      .testResponse(to: .get, at: "heartbeat")
      .assertStatus(is: .ok)
      .assertJSON("beat", equals: beat)
    
    let beat2 = 2
    let heartbeat2 = Heartbeat(beat: beat2)
    let json2 = try heartbeat2.makeJSON()
    let reqBody2 = try Body(json2)
    let req2 = Request(method: .post, uri: "/heartbeat", headers: ["Content-Type": "application/json"], body: reqBody2)
    
    // act & assert
    try drop
      .testResponse(to: req2)
      .assertStatus(is: .ok)
      .assertJSON("beat", equals: beat2)
    
    try drop
      .testResponse(to: .get, at: "heartbeat")
      .assertStatus(is: .ok)
      .assertJSON("beat", equals: beat2)
    
  }
  
  
  func setBeat(to value: Int) throws -> ResponseRepresentable {
    let req = Request.makeTest(method: .post)
    req.json =  try JSON(node: ["beat":value])
    let res = try controller.store(req: req).makeResponse()
    return res
  }
  
}


