// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT






























//// sourcery:inline:auto:City.AutoModelGeneratable

  init(row: Row) throws {
    cityName = try row.get(Keys.cityName)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.cityName, cityName)
    return row
  }
//// sourcery:end
//// sourcery:inline:auto:Content.AutoModelGeneratable

  init(row: Row) throws {
    speechId = try row.get(Keys.speechId)
    type = ContentType(try row.get(Keys.type))
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
    link = try row.get(Keys.link)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.speechId, speechId)
    try row.set(Keys.type, type.string)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    try row.set(Keys.link, link)
    return row
  }
//// sourcery:end
//// sourcery:inline:auto:Creator.AutoModelGeneratable

  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    position = try row.get(Keys.position)
    photoUrl = try row.get(Keys.photoUrl)
    info = try row.get(Keys.info)
    url = try row.get(Keys.url)
    active = try row.get(Keys.active)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.position, position)
    try row.set(Keys.photoUrl, photoUrl)
    try row.set(Keys.info, info)
    try row.set(Keys.url, url)
    try row.set(Keys.active, active)
    return row
  }
//// sourcery:end
//// sourcery:inline:auto:Event.AutoModelGeneratable

  init(row: Row) throws {
    placeId = try row.get(Keys.placeId)
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
    photoUrl = try row.get(Keys.photoUrl)
    isRegistrationOpen = try row.get(Keys.isRegistrationOpen)
    startDate = try row.get(Keys.startDate)
    endDate = try row.get(Keys.endDate)
    hide = try row.get(Keys.hide)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.placeId, placeId)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    try row.set(Keys.photoUrl, photoUrl)
    try row.set(Keys.isRegistrationOpen, isRegistrationOpen)
    try row.set(Keys.startDate, startDate)
    try row.set(Keys.endDate, endDate)
    try row.set(Keys.hide, hide)
    return row
  }
//// sourcery:end
//// sourcery:inline:auto:GiveSpeech.AutoModelGeneratable

  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    return row
  }
//// sourcery:end
//// sourcery:inline:auto:Place.AutoModelGeneratable

  init(row: Row) throws {
    cityId = try row.get(Keys.cityId)
    title = try row.get(Keys.title)
    address = try row.get(Keys.address)
    description = try row.get(Keys.description)
    latitude = try row.get(Keys.latitude)
    longitude = try row.get(Keys.longitude)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.cityId, cityId)
    try row.set(Keys.title, title)
    try row.set(Keys.address, address)
    try row.set(Keys.description, description)
    try row.set(Keys.latitude, latitude)
    try row.set(Keys.longitude, longitude)
    return row
  }
//// sourcery:end
//// sourcery:inline:auto:Speaker.AutoModelGeneratable

  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    eventId = try row.get(Keys.eventId)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.eventId, eventId)
    return row
  }
//// sourcery:end
//// sourcery:inline:auto:Speech.AutoModelGeneratable

  init(row: Row) throws {
    eventId = try row.get(Keys.eventId)
    speakerId = try row.get(Keys.speakerId)
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
    photoUrl = try row.get(Keys.photoUrl)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.eventId, eventId)
    try row.set(Keys.speakerId, speakerId)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    try row.set(Keys.photoUrl, photoUrl)
    return row
  }
//// sourcery:end









